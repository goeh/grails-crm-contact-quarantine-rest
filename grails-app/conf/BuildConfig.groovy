grails.project.class.dir = "target/classes"
grails.project.test.class.dir = "target/test-classes"
grails.project.test.reports.dir = "target/test-reports"
grails.project.target.level = 1.6

grails.project.fork = [
    //  compile: [maxMemory: 256, minMemory: 64, debug: false, maxPerm: 256, daemon:true],
    test: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    run: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    war: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256, forkReserve:false],
    console: [maxMemory: 768, minMemory: 64, debug: false, maxPerm: 256]
]

grails.project.dependency.resolver = "maven"
grails.project.dependency.resolution = {
    inherits "global"
    log "warn"
    repositories {
        grailsCentral()
        mavenLocal()
        mavenCentral()
    }
    dependencies {
        // See https://jira.grails.org/browse/GPHIB-30
        test("javax.validation:validation-api:1.1.0.Final") { export = false }
        test("org.hibernate:hibernate-validator:5.0.3.Final") { export = false }
        // https://mvnrepository.com/artifact/org.codehaus.groovy.modules.http-builder/http-builder
        compile "org.codehaus.groovy.modules.http-builder:http-builder:0.7.1"
    }

    plugins {
        build(":release:3.0.1",
                ":rest-client-builder:1.0.3") {
            export = false
        }
        test(":hibernate4:4.3.6.1") {
            excludes "net.sf.ehcache:ehcache-core"  // remove this when http://jira.grails.org/browse/GPHIB-18 is resolved
            export = false
        }

        test(":codenarc:0.24.1") { export = false }
        test(":code-coverage:2.0.3-3") { export = false }

        compile ":crm-core:2.4.2"
        compile ":crm-security:2.4.2"
        compile ":crm-tags:2.4.1"
        compile ":crm-contact:2.4.2-SNAPSHOT"
        compile ":crm-task:2.4.4-SNAPSHOT"
        compile ":crm-training:2.4.1-SNAPSHOT"
    }
}

codenarc.reports = {
    xmlReport('xml') {
        outputFile = 'target/CodeNarcReport.xml'
    }
    htmlReport('html') {
        outputFile = 'target/CodeNarcReport.html'
    }
}