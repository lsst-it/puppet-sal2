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
    notify => Exec['sal2::obj pip install'],
  }

  # Install the salobj
  # If notify doesn't work, might need an alternative, such as:
  # - compare $version to $install_dir/python/lsst/ts/salobj/version.py
  # - Compare git commit hash (git rev-parse HEAD) to pip freeze
  #   ie: unless => /opt/miniconda3/bin/pip freeze | grep -F $(git --git-dir=/opt/lsst/ts_salobj/.git rev-parse HEAD)
  #   (pip does not report a version string, just the commit hash)
  #   (assume this is a result of installing with the -e flag)
  exec { 'sal2::obj pip install' :
    command     => "pip install -e ${install_dir}",
    path        => $exec_path,
    refreshonly => true,
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
