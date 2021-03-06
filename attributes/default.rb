default['pacemaker']['nodes'] = ['node1', 'node2']

default['pacemaker']['primitive']['drbd']['agent'] = "ocf:linbit:drbd"
default['pacemaker']['primitive']['drbd']['params']['drbd_resource'] = "r0"
default['pacemaker']['primitive']['drbd']['op']['monitor']['interval'] = "5s"
default['pacemaker']['primitive']['drbd']['op']['monitor']['role'] = "Master"
default['pacemaker']['primitive']['drbd']['active'] = ["node1", "node2"]

default['pacemaker']['primitive']['cinder-volume']['agent'] = "ocf:openstack:cinder-volume"
default['pacemaker']['primitive']['cinder-volume']['meta']['is-managed'] = "true"
default['pacemaker']['primitive']['cinder-volume']['meta']['target-role'] = "Started"
default['pacemaker']['primitive']['cinder-volume']['op']['monitor']['interval'] = "10s"
default['pacemaker']['primitive']['cinder-volume']['active'] = ["node1", "node2"]

default['pacemaker']['primitive']['clvm']['agent'] = "ocf:lvm2:clvmd"
default['pacemaker']['primitive']['clvm']['params']['daemon_timeout'] = "30"
default['pacemaker']['primitive']['clvm']['op']['monitor']['interval'] = "5s"
default['pacemaker']['primitive']['clvm']['op']['monitor']['on-fail'] = "restart"
default['pacemaker']['primitive']['clvm']['active'] = ["node1", "node2"]

# Temporary attribute for vip resource.
# Later, vip address will be set by 'ktc-cinder' cookcook and be fetched here.
default['pacemaker']['primitive']['vip']['agent'] = "ocf:heartbeat:IPaddr2"
default['pacemaker']['primitive']['vip']['params']['ip'] = "10.5.2.200"
default['pacemaker']['primitive']['vip']['params']['cidr_netmask'] = "24"
default['pacemaker']['primitive']['vip']['op']['monitor']['interval'] = "3s"
default['pacemaker']['primitive']['vip']['op']['monitor']['nic'] = "eth0"
default['pacemaker']['primitive']['vip']['meta']['target-role'] = "Started"
default['pacemaker']['primitive']['vip']['active'] = ["node1", "node2"]

default['pacemaker']['primitive']['st-node1']['agent'] = "stonith:null"
default['pacemaker']['primitive']['st-node1']['params']['hostlist'] = "node1"
default['pacemaker']['primitive']['st-node1']['active'] = ["node2"]

default['pacemaker']['primitive']['st-node2']['agent'] = "stonith:null"
default['pacemaker']['primitive']['st-node2']['params']['hostlist'] = "node2"
default['pacemaker']['primitive']['st-node2']['active'] = ["node1"]

default['pacemaker']['location']['l-st-node1']['rsc_name'] = "st-node1"
default['pacemaker']['location']['l-st-node1']['priority'] = "-inf"
default['pacemaker']['location']['l-st-node1']['loc'] = "node1"
default['pacemaker']['location']['l-st-node1']['active'] = ["node2"]

default['pacemaker']['location']['l-st-node2']['rsc_name'] = "st-node2"
default['pacemaker']['location']['l-st-node2']['priority'] = "-inf"
default['pacemaker']['location']['l-st-node2']['loc'] = "node2"
default['pacemaker']['location']['l-st-node2']['active'] = ["node1"]

default['pacemaker']['ms']['drbd-cluster']['rsc_name'] = "drbd"
default['pacemaker']['ms']['drbd-cluster']['meta']['master-max'] = "2"
default['pacemaker']['ms']['drbd-cluster']['meta']['master-node-max'] = "1"
default['pacemaker']['ms']['drbd-cluster']['meta']['clone-max'] = "2"
default['pacemaker']['ms']['drbd-cluster']['meta']['clone-node-max'] = "1"
default['pacemaker']['ms']['drbd-cluster']['meta']['notify'] = "true"
default['pacemaker']['ms']['drbd-cluster']['meta']['target-role'] = "Started"
default['pacemaker']['ms']['drbd-cluster']['active'] = ["node1", "node2"]

default['pacemaker']['clone']['clvm-clone']['rsc_name'] = "clvm"
default['pacemaker']['clone']['clvm-clone']['meta']['globally-unique'] = "false"
default['pacemaker']['clone']['clvm-clone']['meta']['interleave'] = "true"
default['pacemaker']['clone']['clvm-clone']['meta']['ordered'] = "true"
default['pacemaker']['clone']['clvm-clone']['active'] = ["node1", "node2"]

default['pacemaker']['colocation']['c-cinder-volume']['priority'] = "inf"
default['pacemaker']['colocation']['c-cinder-volume']['is_multiple'] = "yes"

# Single colocation (if multiple is 'no')
default['pacemaker']['colocation']['c-cinder-volume']['rsc'] = nil
default['pacemaker']['colocation']['c-cinder-volume']['with_rsc'] = nil

# Multiple colocation (if multiple is 'yes')
default['pacemaker']['colocation']['c-cinder-volume']['multiple_rscs'] = ['drbd-cluster', 'vip', 'cinder-volume']
default['pacemaker']['colocation']['c-cinder-volume']['active'] = ["node1", "node2"]

default['pacemaker']['order']['o-lvm']['priority'] = "inf"
default['pacemaker']['order']['o-lvm']['resources'] = ['drbd-cluster', 'clvm-clone', 'vip', 'cinder-volume']
default['pacemaker']['order']['o-lvm']['active'] = ["node1", "node2"]
