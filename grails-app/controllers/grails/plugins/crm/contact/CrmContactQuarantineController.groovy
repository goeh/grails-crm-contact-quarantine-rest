/*
 * Copyright (c) 2016 Goran Ehrsson.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package grails.plugins.crm.contact

import grails.converters.JSON
import grails.plugins.crm.core.DateUtils
import grails.plugins.crm.core.TenantUtils
import grails.plugins.crm.task.CrmTask
import grails.plugins.crm.task.CrmTaskAttender
import grails.transaction.Transactional

import javax.servlet.http.HttpServletResponse
import javax.servlet.http.HttpSession

/**
 * Created by goran on 2016-06-23.
 */
class CrmContactQuarantineController {

    def crmContactQuarantineService
    def crmSecurityService
    def crmContactService
    def crmTaskService
    def crmTrainingService

    def index() {
        def result
        try {
            result = crmContactQuarantineService.list()
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        def currentUser = crmSecurityService.currentUser
        [user: currentUser, result: result]
    }

    def show(String id) {
        def currentUser = crmSecurityService.currentUser
        def contact
        try {
            contact = crmContactQuarantineService.get(id)
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        if(! contact) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
            return
        }
        [user: currentUser, contact: contact, target: identifyTarget(contact)]
    }

    private Object identifyTarget(contact) {
        def target = contact.target
        if (target) {
            def crmTask = crmTaskService.findByNumber(target)
            if (crmTask != null) {
                return crmTask
            }
        }
        null
    }

    def update() {
        def contact
        try {
            contact = crmContactQuarantineService.update(params)
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        flash.success = "${contact.name} uppdaterad"
        redirect action: 'show', id: params.id
    }

    def delete() {
        def selected = params.list('id')
        try {
            for (id in selected) {
                crmContactQuarantineService.delete(id)
            }
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        flash.warning = "${selected.size()} st poster raderade"
        redirect action: 'index'
    }

    def contacts(String id, Long s, String q) {
        def contact
        try {
            contact = crmContactQuarantineService.get(id)
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        def timeout = (grailsApplication.config.crm.quarantine.timeout ?: 60) * 1000
        def result
        if (q) {
            result = crmContactService.list([person: true, name: q], [max: 100])*.dao
        } else {
            result = event(for: 'quarantine', topic: 'duplicates',
                    data: [tenant: TenantUtils.tenant, person: contact]).waitFor(timeout)?.value
        }
        render template: 'contacts', model: [list: result, selected: s]
    }

    def companies(String id, Long s, String q) {
        def contact
        try {
            contact = crmContactQuarantineService.get(id)
        } catch(Exception e) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
            return
        }
        def timeout = (grailsApplication.config.crm.quarantine.timeout ?: 60) * 1000
        def result
        if (q) {
            result = crmContactService.list([company: true, name: q], [max: 100])*.dao
        } else {
            result = event(for: 'quarantine', topic: 'duplicates',
                    data: [tenant: TenantUtils.tenant, company: contact]).waitFor(timeout)?.value
        }
        render template: 'companies', model: [list: result, selected: s]
    }

    def result(String id) {
        render template: 'result', model: [result: getResult(request.session, id)]
    }

    def createCompany(String id) {
        if (request.post) {
            def m = crmContactService.createCompany(params, true)
            if(m.hasErrors()) {
                m = [error: true, errors: m.errors.allErrors]
            } else {
                addResult(request.session, id, m.toString(), [controller: 'crmContact', action: 'show', params: [id: m.id]])
            }
            render m as JSON
        } else {
            def contact
            try {
                contact = crmContactQuarantineService.get(id)
            } catch(Exception e) {
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
                return
            }
            render template: 'createCompany', model: [bean: contact]
        }
    }

    def createPerson(String id, Long company) {
        def related = company ? crmContactService.getContact(company) : null
        if (request.post) {
            if (related != null) {
                def role = crmContactService.getRelationType(params.role)
                params.related = [related, role]
            }
            def m = crmContactService.createPerson(params, true)
            if(m.hasErrors()) {
                m = [error: true, errors: m.errors.allErrors]
            } else {
                addResult(request.session, id, m.toString(), [controller: 'crmContact', action: 'show', params: [id: m.id]])
            }
            render m as JSON
        } else {
            def contact
            try {
                contact = crmContactQuarantineService.get(id)
            } catch(Exception e) {
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
                return
            }
            def roles = crmContactService.listRelationType(null)
            render template: 'createPerson', model: [bean: contact, company: related, roles: roles]
        }
    }

    @Transactional
    def createBooking(String id, Long task, Long booking, Long person) {
        def related = person ? crmContactService.getContact(person) : null
        if (request.post) {
            def crmTask = crmTaskService.getTask(task)
            def status = crmTaskService.getAttenderStatus(params.status)
            def crmTaskBooking = booking ? crmTaskService.getTaskBooking(booking) : null
            def bookingDate = params.bookingDate ? DateUtils.parseDate(params.bookingDate) : new Date()
            if (!crmTaskBooking) {
                crmTaskBooking = crmTaskService.createBooking([task: crmTask, bookingDate: bookingDate], true)
            }
            def m = crmTaskService.addAttender(crmTaskBooking, related, status, params.comments)
            m.bookingDate = bookingDate
            if(m.save()) {
                addResult(request.session, id, crmTask.toString(), [controller: 'crmTaskAttender', action: 'show', params: [id: m.id]])
            } else {
                m = [error: true, errors: m.errors.allErrors]
            }
            render m as JSON
        } else {
            def contact
            try {
                contact = crmContactQuarantineService.get(id)
            } catch(Exception e) {
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
                return
            }
            def crmTask = task != null ? crmTaskService.getTask(task) : null
            def crmTaskAttender = new CrmTaskAttender(contact: related, bookingDate: contact.timestamp)
            def events = crmTrainingService.listTrainingEvents([fromDate: new Date() - 7], [max: 10, sort: 'startTime', order: 'asc'])
            def bookingList = events.bookings.flatten()
            def statusList = crmTaskService.listAttenderStatus()
            render template: 'createBooking',
                    model: [bean        : contact, crmTask: crmTask, crmTaskAttender: crmTaskAttender, person: related,
                            statusList  : statusList, bookingList: bookingList,
                            trainingList: events]
        }
    }

    @Transactional
    def createTask(String id, Long person) {
        def related = person ? crmContactService.getContact(person) : null
        if (request.post) {
            def startDate = params.remove('startDate') ?: formatDate(type: 'date', date: new Date() + 1)
            def startTime = params.remove('startTime') ?: crmTaskService.getDefaultStartTime()
            def m = crmTaskService.createTask(params, false)
            def user = crmSecurityService.getUserInfo(params.username)
            bindDate(m, 'startTime', startDate + ' ' + startTime, user?.timezone)
            if(m.save()) {
                addResult(request.session, id, m.toString(), [controller: 'crmTask', action: 'show', params: [id: m.id]])
            } else {
                m = [error: true, errors: m.errors.allErrors]
            }
            render m as JSON
        } else {
            if (!params.name) {
                params.name = 'Ny aktivitet'
            }
            def contact
            try {
                contact = crmContactQuarantineService.get(id)
            } catch(Exception e) {
                response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE, "Quarantine service not available: ${e.message}")
                return
            }
            def crmTask = crmTaskService.createTask(params, false)
            def typeList = crmTaskService.listTaskTypes()
            def timeList = (7..19).inject([]) { list, h ->
                2.times {
                    list << String.format("%02d:%02d", h, it * 30)
                }; list
            }
            timeList = [''] + timeList.sort()
            render template: 'createTask', model: [bean    : contact, crmTask: crmTask, person: related,
                                                   typeList: typeList, timeList: timeList]
        }
    }

    private void bindDate(CrmTask crmTask, String property, String value, TimeZone timezone = null) {
        if (value) {
            try {
                crmTask[property] = DateUtils.parseDateTime(value, timezone ?: TimeZone.default)
            } catch (Exception e) {
                log.error("error", e)
                def entityName = message(code: 'crmTask.label', default: 'Task')
                def propertyName = message(code: 'crmTask.' + property + '.label', default: property)
                crmTask.errors.rejectValue(property, 'default.invalid.date.message', [propertyName, entityName, value.toString(), e.message].toArray(), "Invalid date: {2}")
            }
        } else {
            crmTask[property] = null
        }
    }

    private void addResult(HttpSession session, String id, String label, Map linkParams) {
        def map = session[id] ?: [:]
        map[linkParams] = label
        session[id] = map
    }

    private Map getResult(HttpSession session, String id) {
        return session[id] ?: [:]
    }
}
