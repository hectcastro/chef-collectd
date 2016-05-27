plugins = node["collectd"]["plugins"]
plugin_support_packages = []

case node["platform_family"]
when "rhel"
  include_recipe "yum-epel"

  plugin_support_packages << "ganglia-devel" if plugins.include?("ganglia")
  plugin_support_packages << "libcurl-devel" if plugins.include?("apache") ||
    plugins.include?("ascent") ||
    plugins.include?("curl") ||
    plugins.include?("nginx") ||
    plugins.include?("write_http")
  plugin_support_packages << "libesmtp-devel" if plugins.include?("notify_email")
  plugin_support_packages << "libgcrypt-devel" if plugins.include?("network")
  plugin_support_packages << "libmemcached-devel" if plugins.include?("memcached")
  plugin_support_packages << "liboping-devel" if plugins.include?("ping")
  plugin_support_packages << "libpcap-devel" if plugins.include?("dns")
  plugin_support_packages << "libvirt-devel" if plugins.include?("virt")
  plugin_support_packages << "libxml2-devel" if plugins.include?("ascent") ||
    plugins.include?("virt")
  plugin_support_packages << "mysql-devel" if plugins.include?("mysql")
  plugin_support_packages << "perl-devel" if plugins.include?("perl")
  plugin_support_packages << "postgresql-devel" if plugins.include?("postgresql")
  plugin_support_packages << "python-devel" if plugins.include?("python")
  plugin_support_packages << "hiredis" if plugins.include?("redis")
  plugin_support_packages << "rrdtool-devel" if plugins.include?("rrdcached") ||
    plugins.include?("rrdtool")
  plugin_support_packages << "varnish-libs-devel" if plugins.include?("varnish")
  plugin_support_packages << "yajl-devel" if plugins.include?("curl_json")
when "debian"
  plugin_support_packages << "libcurl4-openssl-dev" if plugins.include?("apache") ||
    plugins.include?("ascent") ||
    plugins.include?("curl") ||
    plugins.include?("nginx") ||
    plugins.include?("write_http")
  plugin_support_packages << "libesmtp-dev" if plugins.include?("notify_email")
  plugin_support_packages << "libganglia1" if plugins.include?("ganglia")
  plugin_support_packages << "libgcrypt11-dev" if plugins.include?("network")
  plugin_support_packages << "libmemcached-dev" if plugins.include?("memcached")
  plugin_support_packages << "libmysqlclient-dev" if plugins.include?("mysql")
  plugin_support_packages << "liboping-dev" if plugins.include?("ping")
  plugin_support_packages << "libpcap0.8-dev" if plugins.include?("dns")
  plugin_support_packages << "libperl-dev" if plugins.include?("perl")
  plugin_support_packages << "python-dev" if plugins.include?("python")
  plugin_support_packages << "libhiredis-dev" if plugins.include?("redis")
  plugin_support_packages << "librrd-dev" if plugins.include?("rrdcached") ||
    plugins.include?("rrdtool")
  plugin_support_packages << "libvirt-dev" if plugins.include?("virt")
  plugin_support_packages << "libxml2-dev" if plugins.include?("ascent") ||
  plugins.include?("virt")
  plugin_support_packages << "libyajl-dev" if plugins.include?("curl_json")
  plugin_support_packages << "libdbd-mysql" if plugins.include?("dbi")
end

plugin_support_packages.each do |pkg|
    package pkg
end

# treat the graphite plugin specially: set address from search or attributes
if node["collectd"]["plugins"].key?("write_graphite")
  if node["collectd"]["graphite_ipaddress"].empty?
    if Chef::Config[:solo]
      Chef::Application.fatal!("Graphite plugin enabled but no Graphite server configured.")
    end
    graphite_server_results = search(:node, "roles:#{node["collectd"]["graphite_role"]} AND chef_environment:#{node.chef_environment}")

    if graphite_server_results.empty?
      Chef::Application.fatal!("Graphite plugin enabled but no Graphite server found.")
    else
      node.default["collectd"]["plugins"]["write_graphite"]["config"]["Host"] = graphite_server_results[0]["ipaddress"]
    end
  else
    node.default["collectd"]["plugins"]["write_graphite"]["config"]["Host"] = node["collectd"]["graphite_ipaddress"]
  end

  node.default["collectd"]["plugins"]["write_graphite"]["config"]["Port"] = 2003
end

# flush all of configuration to collectd.conf.d/
node["collectd"]["plugins"].each_pair do |plugin_key, definition|
  # Graphite auto-discovery
  collectd_ng_plugin plugin_key.to_s do
    config definition["config"].to_hash if definition["config"]
    template definition["template"].to_s if definition["template"]
    cookbook definition["cookbook"].to_s if definition["cookbook"]
    notifies :restart, "service[collectd]"
  end
end

# flush all of configuration to collectd.conf.d/
node["collectd"]["python_plugins"].each_pair do |plugin_key, definition|
  # Graphite auto-discovery
  collectd_ng_python_plugin plugin_key.to_s do
    typesdb definition["typesdb"].to_s if definition["typesdb"]
    config definition["config"].to_hash
    module_config definition["module_config"].to_hash
    template definition["template"].to_s if definition["template"]
    cookbook definition["cookbook"].to_s if definition["cookbook"]
    notifies :restart, "service[collectd]"
  end
end

conf_d  = "#{node["collectd"]["config_dir"][node['collectd']['install_method']]}/collectd.conf.d"
keys    = node["collectd"]["plugins"].keys.collect { |k| k.to_s }
keys.concat(node["collectd"]["python_plugins"].keys.collect { |k| k.to_s })

if File.exist?(conf_d)
  Dir.entries(conf_d).each do |entry|
    file "#{conf_d}/#{entry}" do
      backup false
      action :delete
      notifies :restart, "service[collectd]"
      only_if { File.file?("#{conf_d}/#{entry}") && File.extname(entry) == ".conf" && !keys.include?(File.basename(entry, ".conf")) }
    end
  end
end
