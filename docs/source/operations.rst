Operations
==========

Identity access management
--------------------------

Bare metal SSH key management - Day 1
-------------------------------------

Public SSH keys can be specified in ``data/authorized_keys`` in the
``drydock/Region/v1`` element. E.g.:

::

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
