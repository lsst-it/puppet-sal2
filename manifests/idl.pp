# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @param rpm_idl_dir
#   Where the rpms installed the idl files (so they can be copied into the
#   git clone target.)
#
# @example
#   include sal2::idl
class sal2::idl (
  String               $git_repo_url,
  Stdlib::Absolutepath $rpm_idl_dir,
  String               $version,
) {

  # get params from parent
  $sal_install_path = lookup( 'sal2::install_path' )

  # useful variables
  $install_dir = "${sal_install_path}/ts_idl"

  # get the git repo
  git { $install_dir :
    branch => "v${version}",
    origin => $git_repo_url,
    notify => Exec['sal2::idl::update_files'],
  }

  # config env file
  $template_params = {
    sal_install_path => $sal_install_path,
    idl_install_path => $install_dir,
  }
  file { "${sal_install_path}/setup_salidl.env" :
    ensure  => file,
    content => epp( 'sal2/setup_salidl.env.epp', $template_params ),
  }

  # Copy idl files from the rpm_idl_dir to the idl_dir
  $src = "${rpm_idl_dir}/sal_revCoded_*.idl"
  $tgt = "${install_dir}/idl"
  exec { 'sal2::idl::update_files' :
    command     => "/bin/cp -pv ${src} ${tgt}",
    onlyif      => [ "test -d ${install_dir}", "test -d ${rpm_idl_dir}" ],
    refreshonly => true,
  }
}
