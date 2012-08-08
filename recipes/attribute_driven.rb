node["collectd"]["plugins"].each_pair do |plugin_key, definition|
  # Graphite auto-discovery
  if plugin_key.to_s == "write_graphite"
    if node["collectd"]["graphite_ipaddress"].empty?
      graphite_server_results = search(:node, "roles:#{node["collectd"]["graphite_role"]} AND chef_environment:#{node.chef_environment}")

      if graphite_server_results.empty?
        Chef::Application.fatal!("Graphite plugin enabled but no Graphite server found.")
      else
        definition["config"]["Host"] = graphite_server_results[0]["ipaddress"]
      end
    else
      definition["config"]["Host"] = node["collectd"]["graphite_ipaddress"]
    end

    definition["config"]["Port"] = 2003
  end

  collectd_plugin plugin_key.to_s do
    config definition["config"].to_hash if definition["config"]
    template definition["template"].to_s if definition["template"]
    cookbook definition["cookbook"].to_s if definition["cookbook"]
  end
end

conf_d  = "#{node["collectd"]["dir"]}/etc/conf.d"
keys    = node["collectd"]["plugins"].keys.collect { |k| k.to_s }

if File.exist?(conf_d)
  Dir.entries(conf_d).each do |entry|
    conf = "#{conf_d}/#{entry}"

    if File.file?(conf) && File.extname(entry) == ".conf" && !keys.include?(File.basename(entry, ".conf"))
      file conf do
        backup false
        action :delete
        notifies :restart, "service[collectd]"
      end
    end
  end
end
