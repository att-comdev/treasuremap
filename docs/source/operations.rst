..
      Copyright 2017 AT&T Intellectual Property.
      All Rights Reserved.

      Licensed under the Apache License, Version 2.0 (the "License"); you may
      not use this file except in compliance with the License. You may obtain
      a copy of the License at

          http://www.apache.org/licenses/LICENSE-2.0

      Unless required by applicable law or agreed to in writing, software
      distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
      WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
      License for the specific language governing permissions and limitations
      under the License.

Operations
==========

Identity access management
--------------------------

Bare metal SSH key management - Day 1
-------------------------------------

Public SSH keys can be specified in ``data/authorized_keys`` in the
``drydock/Region/v1`` element. E.g.::

    ---
    schema: 'drydock/Region/v1'
    data:
      authorized_keys:
        - |
          ssh-rsa YOUR_KEY KEY_NAME

These keys will be deployed for the ``ubuntu`` user after the PXE boot and
deployment of the operating system to the bare metal.

If keys are later added post-deployment, they will only take effect in the event
of a node redeployment.

Bare metal SSH key management - Day 2
-------------------------------------

Not implemented.

View committed site deployment documents
----------------------------------------

View configurations of running services
---------------------------------------

Not implemented.

View rendered Helm chart documents
----------------------------------

Control plane expansion
-----------------------

Data plane expansion
--------------------

Node repurposing and rebuilding
-------------------------------

Logging
-------

General Kubernetes and container workload troubleshooting
---------------------------------------------------------

To get a list of all the pods and their status, run::

    sudo kubectl get pods --all-namespaces

If there are pods **not** in a Running state, this may indicate an issue inside the
container which caused the service to exit (e.g., CrashLoopBackOff), or it may
indicate a Kubernetes issue before even trying to start the container (e.g.,
ImagePullBackOff).

To troubleshoot the failure of a containerized service, display the logs of the
failing service as follows::

    sudo kubectl logs $POD_NAME --namespace=$POD_NAMESPACE

where ``POD_NAME`` is the name of the failing pod, and ``POD_NAMESPACE`` is the
namespace of that pod (as reported in the output of ``sudo kubectl get pods --all-namespaces``).

To troulbeshoot a Kubernetes issue with the pod, use the following command::

    sudo kubectl describe pod $POD_NAME --namespace=$POD_NAMESPACE

This will provide details as to any Kubernetes related failures.
