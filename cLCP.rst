cLCP Deployment
===============

Terminology
-----------

**Cloud**: A platform that provides a standard set of interfaces for `IaaS <https://en.wikipedia.org/wiki/Infrastructure_as_a_service>`_ consumers.

**Undercloud/Overcloud**: When one cloud platform is deployed as a workload onto
the other, these terms are used to disginuish between them.


**`UCP <https://github.com/att-comdev>`_**: (UnderCloud Platform) is the name for a particular suite of products that
make up this undercloud.

**`OSH <https://openstack-helm.readthedocs.io/en/latest/>`_**: (OpenStack Helm) is a collection of Helm charts used to deploy OpenStack
on kubernetes.

**AIC**: AT&T's internal cloud platform, and consumer of UCP + OSH.

**Control Plane**: From the point of view of the cloud service provider, the
control plane refers to the set of resources (hardware, network, storage, etc).
sourced to run cloud services.

**Data Plane**: From the point of view of the cloud service provider, the data
plane is the set of resources (hardware, network, storage, etc). sourced to
provide to run consumer workloads.

**cLCP**: The Containerized Local Control Plane is a term specific to AT&T's
internal cloud platform (AIC). It refers to the control plane of AIC, which is a
combination of OSH with a few additional internal AT&T services.

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

Building Site documents
-----------------------

This section goes over how to put together site documents, and generate the
initial Promenade bundle needed to start the site deployment.

Preparing deployment documents using Twigleg
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Twigleg placeholder - next sectionto be replaced with Twigleg instructions once Twigleg is
publically available.

Preparing deployment documents - the hard way
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Building the Promenade bundle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

More goes here once Twigleg is incroporated.

::

    git clone https://github.com/att-comdev/promenade.git
    sudo promenade/tools/simple-deployment.sh $PATH_TO_PROM_YAMLS build

PATH_TO_PROM_YAMLS must be a directory created containing all site YAMLs
generated from previous sections, except:

::

    schema.yaml
    drydock.yaml

Estimated runtime: About **1 minute** plus **20 seconds per node** defined in
``joining-host-config.yaml``.

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

Estimated runtime: **20m**

In the event of failures, refer to `genesis troubleshooting <https://promenade.readthedocs.io/en/latest/troubleshooting/genesis.html>`_.

Following completion, run the ``validate-genesis.sh`` script to ensure correct
provisioning of the genesis node:

::

    sudo ./validate-genesis.sh

Estimated runtime: **2m**

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

Estimated runtime: **5s**

Deploy Site with Shipyard
^^^^^^^^^^^^^^^^^^^^^^^^^

Start by cloning the shipyard repository to the Genesis node:

::

    git clone https://review.gerrithub.io/att-comdev/shipyard

Next, run the deckhand_load_yaml.sh script as follows:

::

    sudo ./shipyard/tools/deckhand_load_yaml.sh $REGION $PATH_TO_ALL_YAMLS

where REGION is the region name (as defined in drydock.yaml), and PATH_TO_ALL_YAMLS
is the path to a directory containing all YAML files generated in previous
sections.

Estimated runtime: **3m**

Troubleshooting placeholder

Now deploy the site with shipyard:

::

    sudo ./shipyard/tools/deploy_site.sh

Estimated runtime: **1h30m**

Troubleshooting placeholder

The message ``Site Successfully Deployed`` is the expected output at the end of a
successful deployment.

