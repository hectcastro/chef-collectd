include_recipe 'collectd-ng::collectd_build_essentials'

include_recipe 'collectd-ng::install_plugin_dependencies'

include_recipe 'collectd-ng::install_collectd'

#######################
### Configure collectd
######################

template "#{node["collectd"]["dir"]}/etc/collectd.conf" do
  mode "0644"
  source "collectd.conf.erb"
  variables(
    :name         => node["collectd"]["name"],
    :fqdnlookup   => node["collectd"]["fqdnlookup"],
    :dir          => node["collectd"]["dir"],
    :interval     => node["collectd"]["interval"],
    :read_threads => node["collectd"]["read_threads"],
    :write_queue_limit_high => node["collectd"]["write_queue_limit_high"],
    :write_queue_limit_low => node["collectd"]["write_queue_limit_low"],
    :collect_internal_stats => node["collectd"]["collect_internal_stats"],
    :plugins      => node["collectd"]["plugins"],
    :custom_types_db => node["collectd"]["custom_types_db"]
  )
  notifies :restart, "service[collectd]"
end

directory node["collectd"]["plugins_conf_dir"] do
  action :create
end

include_recipe 'collectd-ng::_service'
