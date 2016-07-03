# GR8 CRM - Contact Quarantine REST Plugin

CRM = [Customer Relationship Management](http://en.wikipedia.org/wiki/Customer_relationship_management)

GR8 CRM is a set of [Grails Web Application Framework](http://www.grails.org/)
plugins that makes it easy to develop web application with CRM functionality.
With CRM we mean features like:

- Contact Management
- Task/Todo Lists
- Project Management
- Document Management

The GR8 CRM "Ecosystem" currently contains over 40 Grails plugins. For a complete list of plugins see http://gr8crm.github.io

Each GR8 CRM plugin defines a [Bounded Context](http://martinfowler.com/bliki/BoundedContext.html)
that focus on one specific domain, for example *contact*, *project* or *document*.

The *crm-contact-quarantine* plugin integration with *contact-quarantine-service* microservice.
A microservice that provide temporary storage for contacts collected from external sources.
Contact information that need cleaning and/or validation before importing as "real" contacts into a GR8 CRM application.

Read more about the *crm-contact-quarantine-rest* plugin at [gr8crm.github.io](http://gr8crm.github.io/plugins/crm-contact-quarantine-rest/)
