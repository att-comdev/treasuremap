Treasuremap
===========

This documentation project outlines a reference architecture for automated
cloud provisioning and management, leveraging a collection of interoperable
open-source tools.

.. image:: diagrams/architecture.png

Component Projects
==================

Shipyard
--------
`Shipyard <https://github.com/att-comdev/shipyard>`_ is the directed acyclic
graph controller for Kubernetes and OpenStack control plane life cycle
management.

Shipyard provides the entrypoint for the following aspects of the control plane:

Designs and Secrets
^^^^^^^^^^^^^^^^^^^
Site designs, including the configuration of bare metal host nodes, network 
design, operating systems, Kubernetes nodes, Armada manifests, Helm charts,
and any other descriptors that define the build out of a group of servers enter
the UCP via Shipyard. Secrets, such as passwords and certificates, use the same
mechanism.
The designs and secrets are stored in UCP's Deckhand, providing for version
history and secure storage among other document-based conveniences. 

Actions
^^^^^^^
Interaction with the site's control plane is done via invocation of actions in
Shipyard. Each action is backed by a workflow implemented as a directed acyclic
graph (DAG) that runs using Apache Airflow. Shipyard provides a mechanism to
monitor and control the execution of the workflow. 

Drydock
-------
`Drydock <https://github.com/att-comdev/drydock>`_ is a provisioning orchestrator
for baremetal servers that translates a YAML-based declaritive site topology into a
physical undercloud that can be used for building out a enterprise Kubernetes cluster.
It uses plugins to leverage existing provisioning systems to build the servers allowing
integration with the provisioning system that best fits the goals and environment of a site.

Capabilities
^^^^^^^^^^^^

* Initial IPMI configuration for PXE booting new servers.
* Support for Canonical MAAS 2.2+ provisioning.
* Configuration of complex network topologies including bonding,
  tagged VLANs and static routes
* Support for running behind a corporate proxy
* Extensible boot action system for placing files and SystemD
  units on nodes for post-deployment execution
* Supports Keystone-based authentication and authorization

Divingbell
----------
`Divingbell <https://github.com/att-comdev/divingbell>`_ is a lightweight
solution for:

1. Bare metal configuration management for a few very targeted use cases
2. Bare metal package manager orchestration

What problems does it solve?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The needs identified for Divingbell were:

1. To plug gaps in day 1 tools (e.g., Drydock) for node configuration
2. To provide a day 2 solution for managing these configurations going forward
3. [Future] To provide a day 2 solution for system level host patching

Deckhand
--------
`Deckhand <https://github.com/att-comdev/deckhand>`_ is a document-based
configuration storage service built with auditability and validation in mind. 

Core Responsibilities
^^^^^^^^^^^^^^^^^^^^^

* layering - helps reduce duplication in configuration while maintaining
  auditability across many sites
* substitution - provides separation between secret data and other
  configuration data, while allowing a simple interface for clients
* revision history - improves auditability and enables services to provide
  functional validation of a well-defined collection of documents that are
  meant to operate together
* validation - allows services to implement and register different kinds of
  validations and report errors

Armada
------
`Armada <https://github.com/att-comdev/armada>`_ is a tool for managing multiple
Helm charts with dependencies by centralizing all configurations in a single
Armada YAML and providing life-cycle hooks for all Helm releases.

Kubernetes
----------
`Kubernetes <https://github.com/kubernetes/kubernetes>`_ is an open source
system for managing containerized applications across multiple hosts, providing
basic mechanisms for deployment, maintenance, and scaling of applications.

Promenade
---------
`Promenade <https://github.com/att-comdev/promenade>`_ is a tool for 
bootstrapping a resilient Kubernetes cluster and managing its life cycle.

Helm
----
`Helm <https://github.com/kubernetes/helm>`_ is a package manager for Kubernetes.
It helps you define, install, and upgrade even the most complex Kubernetes
applications using Helm charts.

A chart is a collection of files that describe a related set of Kubernetes
resources. Helm wraps up each chart's deployment into a concrete release,
a tidy little box that is a collection of all the Kubernetes resources that
compose that service, and so you can interact with a collection of Kubernetes
resources that compose a release as a single unit, either to install, upgrade,
or remove.

At its core, the value that Helm brings to the table -- at least for us -- is
allowing us to templatize our experience with Kubernetes resources, providing
a standard interface for operators or high-level software orchestrators to
control the installation and life cycle of Kubernetes applications.  

OpenStack-Helm
--------------
The `OpenStack-Helm <https://github.com/openstack/openstack-helm>`_ project
provides a framework to enable the deployment, maintenance, and upgrading of
loosely coupled OpenStack services and their dependencies individually or as
part of complex environments.

OpenStack-Helm is essentially a marriage of Kubernetes, Helm, and OpenStack,
and seeks to create Helm charts for each OpenStack service.  These Helm charts
provide complete life cycle management for these OpenStack services.

Users of OpenStack-Helm either deploy all or individual OpenStack components
along with their required dependencies.  It heavily borrows concepts from
Stackanetes and complex Helm application deployments.  Ideally, at the end of
the day, this project is meant to be a collaborative project that brings
OpenStack applications into a cloud-native model.

Berth
-----
`Berth <https://github.com/att-comdev/berth>`_ is a deliberately minimalist VM
runner for Kubernetes.

Process Flows
=============

.. image:: diagrams/genesis.png

.. image:: diagrams/deploy_site.png

