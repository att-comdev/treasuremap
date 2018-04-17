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

Troubleshooting time sync issues
--------------------------------

On MaaS-provisioned nodes, ntpd is installed on the bare metal and can be
checked by running the following::

    ntpq -p

Re-run as needed until the ``reach`` is 377 for all of the time sources (i.e.,
the last eight polls to the NTP server were successful). A reach of 0 indicates
a failed NTP server connection, whereas a reach inbetween that never reaches 377
likely indicates network flapping or similar network reliability issue that
should be resolved before proceeding.

For time sources with a 377 ``reach``, ensure that the ``offset`` and ``jitter``
fields are less than 10.000 (miliseconds). Ex::

    .    remote           refid      st t when poll reach   delay   offset  jitter
    ==============================================================================
    +time.tritn.com  63.145.169.3     2 u   48   64  377   54.875    3.533   2.392
    +mis.wci.com     216.218.254.202  2 u   53   64  377   73.954   -2.089   2.538
    *97-127-86-125.m .PPS.            1 u   43   64  377   24.638    0.122   2.686

If the offset is outside tolerance (10.000 ms) but the jitter is not, then the
system time should eventually converge with UTC, and the offset should slowly
reduce over this period.

However, if the jitter is outside tolerance, then there is a problem with the
time sources and/or the network connection to them, and the system time will not
converge nor the offset be reduced until these NTP servers and/or network issues
are resolved.

If the reported offset exceeds 1,000,000 ms (ntpd panic threshold), you should
attempt a one-time correction as follows. (This assumes all workloads from this
node have been suspended or evacuated)::

    sudo apt -y install ntpdate
    sudo service ntp stop
    sudo ntpdate ntp.ubuntu.com  # Or use a local NTP server if this fails
    sudo service ntp start

Troubleshooting IPMI issues
---------------------------

Manual Validation
^^^^^^^^^^^^^^^^^

Drydock already performs validation of IPMI credentials for bare metal nodes it
has configuration data for. However if Drydock is not installed yet, or you want
to do a manual validation, then the following steps show how to do this. This
section also provides troubleshooting steps for how to resolve issues with non-
working IPMI functionality on bare metal nodes.

First install needed utilities on the Genesis host::

    sudo apt -y install ipmitool nmap

Run ipmitool against each out-of-band interface defined in your site manifests,
substituting the IP address, username, and password that are specified in them
(Note: This assumes you can route to out-of-band IPs from the genesis node)::

    ipmitool -I lanplus -H $OOB_IP_ADDR -U $USER -P $PASS chassis status

If successful, an output similar to the following should be received::

    System Power         : on
    Power Overload       : false
    Power Interlock      : inactive
    Main Power Fault     : false
    Power Control Fault  : false
    Power Restore Policy : always-off
    Last Power Event     : command
    Chassis Intrusion    : inactive
    Front-Panel Lockout  : inactive
    Drive Fault          : false
    Cooling/Fan Fault    : false
    Sleep Button Disable : not allowed
    Diag Button Disable  : allowed
    Reset Button Disable : not allowed
    Power Button Disable : allowed
    Sleep Button Disabled: false
    Diag Button Disabled : true
    Reset Button Disabled: false
    Power Button Disabled: false

In this case, IPMI connection and authentication is working properly on this
node. However if unsuccessful, an output similar to the following may be
received::

    Error: Unable to establish IPMI v2 / RMCP+ session

If this happens, check the access to the IPMI port on the target server as
follows::

    sudo nmap -sU -p 623 $OOB_IP_ADDR

If ``nmap`` reports that the port is open, then this can indicate an
authorization issue. Ensure your IPMI credentials are correct and that the node
is running the latest firmware. If the issue still persists, try performing an
iDrac/iLo restart, followed by a password reset.
(Note - UDP scanning is prone to false-positives.)

If ``nmap`` reports that the port is closed, then you should ensure that
``IPMI over LAN`` or equivalent is enabled for the target server. (This allows
the IPMI service to bind to the same IP address used for iDrac/iLo, but on a
different port - UDP 623). Ensure the node is running the latest firmware. If
the issue persists, try performing an iDrac/iLo reset, and toggling the
``IPMI over LAN`` option off and on again.
