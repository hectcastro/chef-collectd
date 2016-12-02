default["collectd"]["version"] =
  case node['platform_family']
  when 'solaris2'
    "5.5.0"
  else
    "5.4.1"
  end

default["collectd"]["checksum"] =
  case node['platform_family']
  when 'solaris2'
    "5f7cfad5b24ed4f8b113cfb270e0f9e5a9f7c3af10443cb507fd40174a6c9028"
  else
    "853680936893df00bfc2be58f61ab9181fecb1cf45fc5cddcb7d25da98855f65"
  end

default["collectd"]["dir"]                = "/opt/collectd"
default["collectd"]["plugins_conf_dir"]    = ::File.join(node["collectd"]["dir"], "etc", "conf.d")
default["collectd"]["url"]                = "http://collectd.org/files/collectd-#{node["collectd"]["version"]}.tar.gz"
default["collectd"]["interval"]           = 10
default["collectd"]["read_threads"]       = 5
default["collectd"]["write_queue_limit_high"] = 1_000_000
default["collectd"]["write_queue_limit_low"] = 800_000
default["collectd"]["collect_internal_stats"] = false
default["collectd"]["name"]               = node["fqdn"]
default["collectd"]["fqdnlookup"]         = true
default["collectd"]["plugins"]            = Mash.new
default["collectd"]["python_plugins"]     = Mash.new
default["collectd"]["graphite_role"]      = "graphite"
default["collectd"]["graphite_ipaddress"] = ""
default['collectd']['solaris'] = {
  'manifest_directory' => '/var/svc/manifest/application',
  'oracle_key_databag' => 'oracle_key',
  'oracle_key_databag_entry' => 'not_real',
  'oracle_key_directory' => '/etc',
  'studio_version' => '12.4'
}
if node['platform_family'] == 'solaris2'
  node.default['ark']['tar'] = '/bin/gtar'
end
default["collectd"]["configure_flag"] = ""
default["collectd"]["custom_types_db"] = ""
