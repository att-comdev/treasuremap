cLCP Deployment
===============

Support
-------

Bugs may be followed against cLCP components as follows:
1. UCP: Bugs may be filed using github issues for UCP projects `here <https://github.com/att-comdev>`_
2. OSH: Bugs may be filed in launchpad `here <https://bugs.launchpad.net/openstack-helm/>`_

Pre-req
-------

1. Ensure your environment has access to the artifactory instance where cLCP artifacts are published.
Note: Install with an environment proxy is currently untested
2. Establish a location you will use to archive/track your configuration documents (e.g., github)

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
3. drydock/NetworkLink/v1 elements - define one for each bond, and the PXE device (if separate from bond)
4. drydock/Network/v1 elements - define one for each logical network (e.g., the networks previously listed in 5a-5e)
5. drydock/HardwareProfile/v1 elements - The information in the HardwareProfile is not used as of this writing. However, a HardwareProfile must be present for Drydock to operate properly.
6. drydock/HostProfile/v1 elements - HostProfile elements must reference a HardwareProfile, and provide a way of grouping hosts by common elements (e.g., host hardware, disk/NIC layout, host designation for different Nova flavor profiles, etc). This example uses two host profiles (one for controller nodes, one for compute nodes).
7. drydock/BaremetalNode/v1 - define a BareMetalNode element for each physical server in your environment. Assign addresses for each network interface according to the ranges available on these networks.

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

Setting up Genesis node
-----------------------

Start with a manual install of Ubuntu 16.04 on the node you wish to use to seed the rest of your environment.

