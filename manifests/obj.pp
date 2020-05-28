# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include sal2::obj
class sal2::obj (
  String $git_repo_url,
  String $version,
) {

  # get params from parent
  $sal_install_path = lookup( 'sal2::install_path' )
  $exec_path = lookup( 'sal2::exec_path' )

  # useful variables
  $install_dir = "${sal_install_path}/ts_salobj"

  # get the git repo
  git { $install_dir :
    branch => "v${version}",
    origin => $git_repo_url,
  }

  # Install the salobj
  # TODO - What does this create? How to prevent running for every agent run?
  # "/opt/miniconda/bin/pip install -e $install_dir"
  exec { 'sal2::obj pip install' :
    command => "pip install -e ${install_dir}",
    path    => $exec_path,
    creates => ,
  }

  # config env file
  $template_params = {
    sal_install_path => $sal_install_path,
    salobj_install_path => $install_dir,
  }
  file { "${sal_install_path}/setup_salobj.env" :
    ensure  => file,
    content => epp( 'sal2/setup_salobj.env.epp', $template_params ),
  }

}
