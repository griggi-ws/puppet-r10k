# @summary install and configure the webhook-go package as local webhook receiver to trigger r10k runs
#
# @param install_method
#   how the package should be installed
# @param ensure
# @param version
# @param service_ensure
# @param service_enabled
# @param config_ensure
# @param config_path
# @param chatops
# @param chatops_default
# @param tls
# @param server
# @param server_default
# @param r10k
# @param r10k_default
# @param config
#
class r10k::webhook (
  Enum['package', 'repo', 'none'] $install_method = 'package',
  Boolean $ensure = false,
  String $version = '2.2.0',
  Variant[
    Enum['running', 'stopped'],
    Boolean
  ] $service_ensure = 'running',
  Boolean $service_enabled = true,
  String $config_ensure                      = 'file',
  String $config_path                        = '/etc/voxpupuli/webhook.yml',
  R10k::Webhook::Config::ChatOps $chatops    = {},
  Optional[R10k::Webhook::Config::ChatOps] $chatops_default    = {
    enabled    => false,
    service    => undef,
    channel    => undef,
    user       => undef,
    auth_token => undef,
    server_uri => undef,
  },
  R10k::Webhook::Config::Server::Tls $tls    = {
    enabled     => false,
    certificate => undef,
    key         => undef,
  },
  R10k::Webhook::Config::Server $server    = {},
  Optional[R10k::Webhook::Config::Server] $server_default      = {
    protected => true,
    user      => 'puppet',
    password  => 'puppet',
    port      => 4000,
    tls       => $tls,
  },
  R10k::Webhook::Config::R10k $r10k    = {},
  Optional[R10k::Webhook::Config::R10k] $r10k_default = {
    command_path    => '/opt/puppetlabs/puppet/bin/r10k',
    config_path     => '/etc/puppetlabs/r10k/r10k.yaml',
    default_branch  => 'production',
    prefix          => undef,
    allow_uppercase => false,
    verbose         => true,
    deploy_modules  => true,
    generate_types  => true,
  },
  R10k::Webhook::Config $config              = {
    server  => $server_default + $server,
    chatops => $chatops_default + $chatops,
    r10k    => $r10k_default + $r10k,
  },
) inherits r10k::params {
  contain r10k::webhook::package
  contain r10k::webhook::config
  contain r10k::webhook::service

  Class['r10k::webhook::package']
  -> Class['r10k::webhook::config']
  ~> Class['r10k::webhook::service']
}
