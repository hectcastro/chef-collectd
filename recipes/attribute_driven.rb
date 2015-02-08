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

# flush all of configuration to conf.d/
node["collectd"]["plugins"].each_pair do |plugin_key, definition|
  # Graphite auto-discovery
  collectd_plugin plugin_key.to_s do
    config definition["config"].to_hash if definition["config"]
    template definition["template"].to_s if definition["template"]
    cookbook definition["cookbook"].to_s if definition["cookbook"]
  end
end

# flush all of configuration to conf.d/
node["collectd"]["python_plugins"].each_pair do |plugin_key, definition|
  # Graphite auto-discovery
  collectd_python_plugin plugin_key.to_s do
    typesdb definition["typesdb"].to_s if definition["typesdb"]
    config definition["config"].to_hash
    module_config definition["module_config"].to_hash
    template definition["template"].to_s if definition["template"]
    cookbook definition["cookbook"].to_s if definition["cookbook"]
  end
end

conf_d  = "#{node["collectd"]["dir"]}/etc/conf.d"
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
