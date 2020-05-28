# @summary Install and configure the LSST Service Abstraction Layer (SAL)
#
# Install and configure the LSST Service Abstraction Layer (SAL)
#
# @example
#   include sal2
class sal2 (
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
