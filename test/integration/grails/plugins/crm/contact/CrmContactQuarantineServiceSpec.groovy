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

import grails.plugins.crm.core.CrmContactInformation
import grails.plugins.crm.core.TenantUtils

/**
 * Created by goran on 2016-06-21.
 */
class CrmContactQuarantineServiceSpec extends grails.test.spock.IntegrationSpec {

    def grailsApplication
    def crmContactQuarantineService

    def "test constraints"() {
        given:
        new CrmContactQuarantine(tenantId: 3, number: "42", companyName: "Grails Inc.").save(failOnError: true, flush: true)

        when:
        def contact = new CrmContactQuarantine()

        then: "nothing is mandatory"
        contact.validate()

        when:
        contact = new CrmContactQuarantine(tenantId: 3, number: "42", companyName: "I'm a duplicate number")

        then: "duplicate customer numbers are ok"
        contact.validate()
    }

    def "test transient methods"() {
        when:
        def contact = new CrmContactQuarantine(tenantId: 1, companyName: "ACME Inc.")

        then:
        contact.toString() == 'ACME Inc.'

        when:
        contact.firstName = 'Lisa'
        contact.lastName = 'Simpson'

        then:
        contact.toString() == 'Lisa Simpson'
        contact.getFullName() == 'Lisa Simpson, ACME Inc.'

        when:
        contact.companyName = null

        then:
        contact.toString() == 'Lisa Simpson'
        contact.getFullName() == 'Lisa Simpson'
    }

    def "test service"() {
        when:
        CrmContactInformation contact = TenantUtils.withTenant(1L) {
            crmContactQuarantineService.quarantine(
                    firstName: 'Göran',
                    lastName: 'Ehrsson',
                    companyName: 'Technipelago AB',
                    title: 'Developer',
                    email: 'goran@technipelago.se',
                    comments: 'This is a test'
            )
        }

        then:
        !contact.hasErrors()
        contact.getFullName() == 'Göran Ehrsson, Technipelago AB'
        contact.getEmail() == 'goran@technipelago.se'
    }

    def "test remote service"() {
        when:
        def result = crmContactQuarantineService.list(1, "test")

        then:
        result instanceof Collection
    }
}
