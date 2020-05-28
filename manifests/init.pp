# @summary Install and configure the LSST Service Abstraction Layer (SAL)
#
# Install and configure the LSST Service Abstraction Layer (SAL)
#
# @param exec_path
#        Set path for execs.
#        Use for allowing custom 'python' and 'pip' to be found.
#
# @param install_path
#        Directory under which everything will be installed.
#
# @example
#   include sal2
class sal2 (
  Array  $exec_path,
  String $install_path,
) {

  include ::sal2::rpm
  include ::sal2::dds
  include ::sal2::idl
  include ::sal2::obj

  file { $install_path :
    ensure => directory,
  }
}
