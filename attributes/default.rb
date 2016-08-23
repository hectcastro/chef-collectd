
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

default["collectd"]["source"]["version"]            = "5.4.1"
default["collectd"]["source"]["base_dir"]           = "/opt/collectd"
default["collectd"]["source"]["config_file"]        = ::File.join(node["collectd"]["source"]["base_dir"], "etc", "collectd.conf")
default["collectd"]["source"]["plugins_conf_dir"]   = ::File.join(node["collectd"]["source"]["base_dir"], "etc", "conf.d")
default["collectd"]["source"]["plugins_dir"]        = ::File.join(node["collectd"]["source"]["base_dir"], "lib", "collectd")
default["collectd"]["source"]["types_dir"]        = ::File.join(node["collectd"]["source"]["base_dir"], "share", "collectd")
default["collectd"]["source"]["url"]                = "http://collectd.org/files/collectd-#{node["collectd"]["version"]}.tar.gz"
default["collectd"]["source"]["checksum"]           = "853680936893df00bfc2be58f61ab9181fecb1cf45fc5cddcb7d25da98855f65"

default["collectd"]["package"]["dir"]               = "/var/lib/collectd"
default["collectd"]["package"]["config_file"]       = "/etc/collectd.conf"
default["collectd"]["package"]["plugins_conf_dir"]  = "/etc/collectd.d"
default["collectd"]["package"]["plugins_dir"]        = "/usr/lib64/collectd"
default["collectd"]["package"]["types_dir"]         = "/usr/share/collectd/"

