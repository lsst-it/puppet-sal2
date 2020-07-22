# @summary Install and configure the LSST Service Abstraction Layer (SAL)
#
# Install and configure the LSST Service Abstraction Layer (SAL).
#
# Includes:
# - OpenSplice
# - ts-dds
# - ts_idl
# - ts_salobj
#
# @param install_dir
#        Directory under which everything will be installed.
#
# @param ospl_version
#        Version of OpenSplice to install.
#        Used by both yum installer (for OpenSplice)
#        and conda installer (for ts-dds)
#
# @param ospl_yumrepo_data
#        `baseurl` and `descr` are required. Any other valid
#        Puppet yumrepo parameters are optional.
#
# @param ts_idl_version
#        Full version string as needed by conda package installer
#        Format: <IDLversion>_<XMLversion>
#
# @param ts_salobj_version
#        Full version string as needed by conda package installer
#
# @param required_os_pkgs
#        Other OS packages required by SAL
#
# @example
#   include sal2
class sal2 (
  String $install_dir,
  String $ospl_version,
  String $ospl_rpm_version,
  Hash   $ospl_yumrepo_data,
  Array  $required_os_pkgs,
  String $ts_idl_version,
  String $ts_salobj_version,
  String $ts_dds_version,
) {

  file { $install_dir :
    ensure  => directory,
      mode  => '0755',
      owner => 'root',
  }


  # Dependent OS packages
  ensure_packages( $required_os_pkgs )


  # Ensure OpenSplice is installed
  yumrepo {
    'lsst-ts':
      * => $ospl_yumrepo_data,
    ;
    default:
      gpgcheck       => 0,
      failovermethod => 'priority',
    ;
  }
  # T&S rpm's don't allow upgrade in place, manually uninstall first
  exec { 'uninstall OpenSpliceDDS' :
    onlyif  => 'yum list installed | grep OpenSpliceDDS',
    unless  => "yum list installed | grep OpenSpliceDDS | grep '${ospl_rpm_version}'",
    path    => '/bin/:/sbin/:/usr/bin/:/usr/sbin/',
    cwd     => '/',
    command => "yum list installed | grep OpenSpliceDDS | cut -d' ' -f1 | xargs -- yum -y remove",
  }
  $ospl_pkg_list = [ "OpenSpliceDDS-${ospl_rpm_version}" ]
  $ospl_pkg_defaults = {
    'ensure'  => 'present',
    'require' => Exec['uninstall OpenSpliceDDS'],
  }
  ensure_packages( $ospl_pkg_list, $ospl_pkg_defaults )


  # ENV files
  $params_sal = { ospl_version => $ospl_version, }
  $params_salobj = { sal_install_dir    => $install_dir, }
  file {
    "${install_dir}/setup_SAL.env" :
      content => epp( 'sal2/setup_SAL.env.epp', $params_sal ),
    ;
    "${install_dir}/setup_salobj.env" :
      content => epp( 'sal2/setup_salobj.env.epp', $params_salobj ),
    ;
    default:
      ensure => file,
      mode   => '0444',
      owner  => 'root',
  }


  # Ensure T&S conda packages
  $ts_packages = [
    "ts-dds==v${ts_dds_version}",
    "ts-idl=${ts_idl_version}",
    "ts-salobj=${ts_salobj_version}",
  ]
  miniconda::package { $ts_packages : }

}
