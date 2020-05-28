# @summary Install SAL rpm repo and packages
#
# Install SAL rpm repo and packages
#
# @example
#   include sal2::rpm
class sal2::rpm {
  Array  $packages,
  Array  $required_os_pkgs,   #TODO - ARE THESE REALLY NEEDED?
  String $ts_sal_version,
  String $ts_xml_version,
  Hash   $yum_repos,
) {

  #TODO - ARE THESE REALLY NEEDED?
  # Dependent packages
  ensure_packages( $required_os_pkgs )

  # Ensure yum repos are installed
  $yumrepo_defaults = {
    gpgcheck => 0,
    failovermethod => 'priority',
  }
  $yum_repos.each | $name, $data | {
    yumrepo{
      $name:
        * => $data,
      ; 
      default:
        * => $yumrepo_defaults,
      ;
  }

  # Install TS packages
  $rpm_version = "${ts_sal_version}-${ts_xml_version}.el7"
  $defaults = {
    ensure => $rpm_version,
  }
  ensure_packages( $packages, $defaults )

}
