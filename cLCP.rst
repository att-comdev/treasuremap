cLCP Deployment
===============

Terminology
-----------

cLCP refers to the specific coupling of UCP undercloud with OSH overcloud.

`UCP <https://github.com/att-comdev>`_ (UnderCloud Platform) is the name for a particular suite of products that
make up this undercloud.

`OSH <https://openstack-helm.readthedocs.io/en/latest/>`_ (OpenStack Helm) is a collection of Helm charts used to deploy OpenStack on
kubernetes.

Control Plane

Data Plane

Node overview
^^^^^^^^^^^^^

This document refers to several types of nodes, which vary in their purpose, and
to some degree in their orchestration / setup:

- Build node: This refers to the environment where configuration documents are
  built for your environment.
- Genesis node: The "genesis" or "seed node" refers to a short-lived node used
  to get a new deployment off the ground, and is the first node built in a new
  deployment environment.

Support
-------

Bugs may be followed against cLCP components as follows:
1. General cLCP: If you're unsure of the root cause of an issue, you may file it
   in the Github issues for Treasuremap `here <https://github.com/att-comdev/treasuremap/issues`_.
   However, if you know the root issue, then the more expedient path to issue
   resolution is to file bugs against OSH and specific UCP projects as follows.
#. UCP: Bugs may be filed using github issues for specific UCP projects `here <https://github.com/att-comdev>`_.
#. OSH: Bugs may be filed against OpenStack Helm in launchpad `here <https://bugs.launchpad.net/openstack-helm/>`_.

Pre-req
-------

1. Ensure your environment has access to the artifactory instance where
cLCP artifacts are published.
#. Establish a location you will use to archive/track your configuration
documents (e.g., github)

Example deployment scenario
---------------------------

This example goes through a single rack, 4-node deployment: a genesis host (initial seed host), two control plane nodes, and one data plane / compute node.

Environment assumptions
-----------------------

1. Control plane server HDDs configured for JBOD (for Ceph)
2. IPMI enabled in server BIOS
3. IPMI IPs assigned, and reachable from controller nodes (from VLAN ID 103 in this example)
4. You have a network you can successfully PXE boot with your network topology and bonding settings (dedicated interace, untagged/native VLAN in this example)
5. You have segmented, routed networks accessible by all nodes for:
5a. Management network(s) (k8s control channel)
5b. Calico network(s)
5c. Storage network(s)
5d. Overlay network(s)
5e. Public network(s)

HW Sizing and minimum requirements
----------------------------------

Establishing build node environment
-----------------------------------

1. On the machine you wish to sue to generate deployment files, install required
   tooling:

::

    sudo apt -y install docker.io git

2. Clone the promenade git repo:

::

    git clone https://github.com/att-comdev/promenade

Preparing deployment documents using Twigleg
--------------------------------------------

Twigleg placeholder - to be replaced with Twigleg instructions once Twigleg is
publically available.

Preparing deployment documents - the hard way
---------------------------------------------

You will need to prepare the following documents according to your environment's settings.

This section will highlight environment-specific parameters in these documents.

::

    sample/osh/armada.yaml

1. Ceph chart CIDRs (this sample uses PXE CIDRs)
2. Nova chart metadata IP (?)

::

    sample/ucp/drydock.yaml

1. Region name (e.g., cab22-2)
2. Authorized ssh keys (replace with your key(s) for SSH key distribtuion)
3. drydock/NetworkLink/v1 elements - define one for each bond, and the PXE
   device (if separate from bond)
4. drydock/Network/v1 elements - define one for each logical network (e.g., the
   networks previously listed in 5a-5e)
5. drydock/HardwareProfile/v1 elements - The information in the HardwareProfile
   is not used as of this writing. However, a HardwareProfile must be present for Drydock to operate properly.
6. drydock/HostProfile/v1 elements - HostProfile elements must reference a
   HardwareProfile, and provide a way of grouping hosts by common elements
   (e.g., host hardware, disk/NIC layout, host designation for different Nova
   flavor profiles, etc). This example uses two host profiles (one for
   controller nodes, one for compute nodes).
7. drydock/BaremetalNode/v1 - define a BareMetalNode element for each physical
   server in your environment. Assign addresses for each network interface
   according to the ranges available on these networks.

::

    sample/ucp/promenade/bootstrap-armada-config.yaml

1. Ceph chart CIDRs
2. k8s ingress CIDR
3. etcdctl_endpoint IP (?)
4. 

::

    sample/ucp/promenade/genesis-config.yaml

1. Genesis node IP address (select available adderss on PXE network)

::

    sample/ucp/promenade/joining-host-config.yaml

1.

::

    sample/ucp/promenade/site-config.yaml

1.

Genesis node
------------

Initial setup
^^^^^^^^^^^^^

Start with a manual install of Ubuntu 16.04 on the node you wish to use to seed
the rest of your environment. Ensure the host has outbound internet access and
can resolve public DNS entries.

Ensure that the hostname matches the hostname specified in the Genesis.yaml file
used in the previously generated configuration. If it does not, then either
change the hostname of the node to match the configuration documents, or re-
generate the configuration with the correct hostname.

Promenade bootstrap
^^^^^^^^^^^^^^^^^^^

Copy the ``genesis.sh`` script generated in the promenade bundle on the build
node to the genesis node and run it as sudo:

::

    sudo ./genesis.sh

This is expected to take 15-20 minutes. In the event of failures, refer to
`genesis troubleshooting <https://promenade.readthedocs.io/en/latest/troubleshooting/genesis.html>`_.

Following completion, run the ``validate-genesis.sh`` script to ensure correct
provisioning of the genesis node:

::

    sudo ./validate-genesis.sh

Nginx server workaround
^^^^^^^^^^^^^^^^^^^^^^^

Currently it is necessary to setup a web server to host the other Promenade
bundle build artifacts, so that new nodes PXE booted into the environment can
retrieve their ``join-<NODE>.sh`` scripts and run them, without a manual
execution.

At present, you may use the genesis node for this purpose (and defer genesis
teardown until some later time when this workaround is no longer necessary).

Copy all of the Promenade build artifacts to the genesis node, then run the
following after substituting local disk path to the promenade artifacts that
were copioed onto the genesis node:

::

    sudo docker run -d -v $PATH_TO_PROMENADE_BUNDLE:/usr/share/nginx/html -p 6880:80 nginx

