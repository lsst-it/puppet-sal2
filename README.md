# SAL2
 
Install SAL components
 
## Dependencies
- [puppet/miniconda](https://github.com/lsst-it/puppet-miniconda)
 
## Reference

### class sal2::firewall (
-  String[9]          $multicast_cidr,
-  Array[String[1],1] $omgdds_ports,
-  Array[String[1],1] $omgdds_subnets,
-  Array[String[1],1] $opensplice_ports,
-  Array[String[1],1] $opensplice_subnets,
### class sal2 (
-  String $install_dir,
-  String $ospl_version,
-  Hash   $ospl_yumrepo_data,
-  Array  $required_os_pkgs,
-  String $ts_idl_version,
-  String $ts_salobj_version,

[REFERENCE.md](REFERENCE.md)
