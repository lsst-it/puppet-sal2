# @summary Install opensplice dds
#
# Install opensplice dds
#
# @param ospl_package_name
#        Package name according to yum
#
# @example
#   include sal2::dds
class sal2::dds (
  String $ospl_package_name,
) {

  # get params from parent class
  $install_path = lookup( 'sal2::install_path' )
  $exec_path = lookup( 'sal2::exec_path' )

  # define useful variables
  $sal_env_file = "${install_path}/setup_SAL.env"
  $setup_dds_file = "${install_path}/setup_dds.sh"

  # ensure dds setup script file
  $template_params = {
    ospl_package_name => $ospl_package_name,
    sal_env_file      => $sal_env_file,
  }
  file { $setup_dds_file :
    ensure   => file,
    contents => epp( 'sal2/setup_dds.sh.epp', $template_params ),
    mode     => '0500',
    owner    => 'root',
  }

  # run setup script
  exec { 'sal2::dds setup' :
    command     => $setup_dds_file,
    path        => $exec_path,
    require     => File[$setup_dds_file],
    refreshonly => true,
  }

}
