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

This example goes through a 4-node deployment: a genesis host (initial seed host), two control plane nodes, and one data plane / compute node.

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

You will need to prepare the following documents according to your environment's settings:

```
- osh/armada.yaml
- ucp/drydock.yaml
- ucp/promenade/bootstrap-armada-config.yaml
- ucp/promenade/genesis-config.yaml
- ucp/promenade/joining-host-config.yaml
- ucp/promenade/site-config.yaml
```
More details about pertinant parameters of interest will be forthcoming.

Setting up Genesis node
-----------------------

Start with a manual install of Ubuntu 16.04 on the node you wish to use to seed the rest of your environment.

