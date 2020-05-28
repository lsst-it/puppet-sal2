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

  # useful variables
  $install_dir = "${sal_install_path}/ts_salobj"

  # get the git repo
  git { $install_dir :
    branch => "v${version}",
    origin => $git_repo_url,
  }

  # Install the salobj
  # TODO - Need to use the miniconda pip
  # "/opt/miniconda/bin/pip install -e $install_dir"

  # config env file
  $template_params = {
    sal_install_path => $sal_install_path,
    salobj_install_path => $install_dir,
  }
  file { "${sal_install_path}/setup_salobj.env" :
    ensure  => file,
    content => epp( 'sal2/setup_salobj.epp', $template_params ),
  }

}
