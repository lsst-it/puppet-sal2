# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`sal2`](#sal2): Install and configure the LSST Service Abstraction Layer (SAL)
* [`sal2::firewall`](#sal2firewall): Setup firewall exceptions for SAL components

## Classes

### sal2

Install and configure the LSST Service Abstraction Layer (SAL).

Includes:
- OpenSplice
- ts-dds
- ts_idl
- ts_salobj

#### Examples

##### 

```puppet
include sal2
```

#### Parameters

The following parameters are available in the `sal2` class.

##### `install_dir`

Data type: `String`

Directory under which everything will be installed.

##### `ospl_version`

Data type: `String`

Version of OpenSplice to install.
Used by both yum installer (for OpenSplice)
and conda installer (for ts-dds)

##### `ospl_yumrepo_data`

Data type: `Hash`

`baseurl` and `descr` are required. Any other valid
Puppet yumrepo parameters are optional.

##### `ts_idl_version`

Data type: `String`

Full version string as needed by conda package installer
Format: <IDLversion>_<XMLversion>

##### `ts_salobj_version`

Data type: `String`

Full version string as needed by conda package installer

##### `required_os_pkgs`

Data type: `Array`

Other OS packages required by SAL

### sal2::firewall

Setup firewall exceptions for SAL components.

See also:
- https://gist.github.com/juliojsb/00e3bb086fd4e0472dbe
- https://community.rti.com/content/forum-topic/statically-configure-firewall-let-omg-dds-traffic-through
- https://github.com/lsst-ts/ts_sal/blob/develop/lsstsal/doc/SAL_User_Guide.pdf

#### Examples

##### 

```puppet
include sal2::firewall
```

#### Parameters

The following parameters are available in the `sal2::firewall` class.

##### `multicast_cidr`

Data type: `String[9]`

Allow all multicast traffic from/to this address.

Default value: `127.0.0.1/32`

##### `omgdds_ports`

Data type: `Array[String[1],1]`

UDP port ranges to open for omg dds.
Values must be strings that are valid format for iptables.

Default values:
- `7400-32399`
- `32768-65535`

##### `omgdds_subnets`

Data type: `Array[String[1],1]`

Allow incoming OMG DDS multicast/unicast input from these IP's/masks/CIDR's.
Values must be strings that are valid iptables source masks.

Default values:
- `127.0.0.1/32`

##### `opensplice_ports`

Data type: `Array[String[1],1]`

UDP port ranges to open for opensplice.
Values must be strings that are valid format for iptables.

Default values:
- `250-251`

##### `opensplice_subnets`

Data type: `Array[String[1],1]`

Allow incoming OpenSplice traffic from these IP's/masks/CIDR's.
Values must be strings that are valid iptables source masks.

Default values:
- `127.0.0.1/32`

