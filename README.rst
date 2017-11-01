Treasuremap
===========

This documentation project outlines a reference architecture for automated
cloud provisioning and management, leveraging a collection of interoperable
open source tools.

Overview
--------

.. image:: diagrams/architecture.png

Component Projects
==================

Shipyard
--------
`Shipyard <https://github.com/att-comdev/shipyard>` is the directed acyclic
graph controller for Kubernetes and OpenStack control plane life cycle
management.

Shipyard provides the entrypoint for the following aspects of the control plane:

Designs and Secrets
^^^^^^^^^^^^^^^^^^^
Site designs, including the configuration of bare metal host nodes, network 
design, operating systems, Kubernetes nodes, Armada manifests, Helm charts,
and any other descriptors that define the build out of a group of servers enter
the UCP via Shipyard. Secrets, such as passwords and certificates use the same
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
`Drydock <https://github.com/att-comdev/drydock>` is a python REST orchestrator
to translate a YAML host topology to a provisioned set of hosts and provide a
set of cloud-init post-provisioning instructions.

Deckhand
--------
`Deckhand <https://github.com/att-comdev/deckhand>` is a document-based
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
`Armada <https://github.com/att-comdev/armada>` is a tool for managing multiple
helm charts with dependencies by centralizing all configurations in a single
Armada yaml and providing lifecycle hooks for all helm releases.

Kubernetes
----------
`Kubernetes <https://github.com/kubernetes/kubernetes>` is an open source system
for managing containerized applications across multiple hosts, providing basic
mechanisms for deployment, maintenance, and scaling of applications.

Promenade
---------
`Promenade <https://github.com/att-comdev/promenade>` is a tool for 
bootstrapping a resilient Kubernetes cluster and managing its life-cycle.

Helm
----
`Helm <https://github.com/kubernetes/helm>` is a package manager for Kubernetes.It helps you define, install, and upgrade even the most complex Kubernetes
applications using helm charts.

A chart is a collection of files that describe a related set of Kubernetes
resources. Helm wraps up each charts deployment into a concrete release,
a tidy little box that is a collection of all the Kubernetes resources that
compose that service, and so you can interact with a collection of Kubernetes
resources that compose a release as a single unit, either to install, upgrade,
or remove.

At its core, the value that helm brings to the table at least for us is
allowing us to templatize our experience with Kubernetes resources, providing
a standard interface for operators or high level software orchestrators to
control the installation and life cycle of Kubernetes applications.  

OpenStack-Helm
--------------
The `OpenStack-Helm <https://github.com/openstack/openstack-helm>` project
provides a framework to enable the deployment, maintenance, and upgrading of
loosely coupled OpenStack services and their dependencies individually or as
part of complex environments.

OpenStack-Helm is essentially a marriage of Kubernetes, Helm, and OpenStack,
and seeks to create helm charts for each OpenStack service.  These helm charts
provide complete life cycle management for these OpenStack services.

Users of OpenStack-Helm either deploy all or individual Openstack components
along with their required dependencies. It heavily borrows concepts from
Stackanetes and complex Helm application deployments.  Ideally, at the end of
the day, this project is meant to be a collaborative project that brings
Openstack applications into a cloud-native model.

Berth
-----
`Berth <https://github.com/att-comdev/berth>` is a deliberately minimalist VM
runner for Kubernetes.

Process Flows
=============

.. image:: diagrams/genesis.png

.. image:: diagrams/deploy_site.png

