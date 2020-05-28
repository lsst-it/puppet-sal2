# SAL2
 
Install SAL components
 
## Dependencies
- [puppet/git_resource](https://forge.puppet.com/puppet/git_resource)
- [puppet/miniconda](https://github.com/lsst-it/puppet-miniconda)
 
## Reference

### class sal2::obj (
-  String $git_repo_url,
-  String $version,
### class sal2::dds (
-  String $ospl_package_name,
### class sal2::idl (
-  String               $git_repo_url,
-  Stdlib::Absolutepath $rpm_idl_dir,
-  String               $version,
### class sal2 (
-  Array  $exec_path,
-  String $install_path,
-  Array  $required_os_pkgs,
### class sal2::rpm (
-  Array  $packages,
-  String $ts_sal_version,
-  String $ts_xml_version,
-  Hash   $yum_repos,
 
[REFERENCE.md](REFERENCE.md)
