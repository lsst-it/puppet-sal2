# @summary Install opensplice dds
#
# Install opensplice dds
#
# @example
#   include sal2::dds
class sal2::dds (
  String $ospl_version,
) {

  # get params from parent class
  $install_path = lookup( 'sal2::install_path' )

  # define useful variables
  $ospl_home = "/opt/OpenSpliceDDS/V${ospl_version}/HDE/x86_64.linux"
  $sal_env_file = "${install_path}/setup_SAL.env"

  # ensure env setup file
  $template_params = {
    ospl_home => $ospl_home,
  }
  file { $sal_env_file :
    ensure   => file,
    contents => epp( 'sal2/setup_SAL.epp', $template_params ),
  }

  # TODO - how does the CWD get there?
  #        Assume it is part of sal2::rpm from $packages
  # TODO - NEEDS TO USE THE MINICONDA PYTHON
  # run python installer
  exec { 'sal2::dds setup.py install' :
    command => "source ${sal_env_file} && /bin/python3 setup.py install",
    creates => ,
    cwd     => "${ospl_home}/tools/python/src",
    require => [ Class['python'], File[$sal_env_file], Class['sal2::rpm'] ],
  }

}
