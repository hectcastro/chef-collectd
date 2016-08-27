node["collectd"]["packages"].each do |pkg|
  package pkg
end

template node["collectd"]["package"]["config_file"] do
  mode "0644"
  source "collectd.conf.erb"
  variables(
    :name         => node["collectd"]["name"],
    :fqdnlookup   => node["collectd"]["fqdnlookup"],
    :base_dir     => node["collectd"]["package"]["base_dir"],
    :plugins_conf_dir  => node["collectd"]["package"]["plugins_conf_dir"],
    :plugins_dir  => node["collectd"]["package"]["plugins_dir"],
    :types_dir    => node["collectd"]["package"]["types_dir"],
    :interval     => node["collectd"]["interval"],
    :read_threads => node["collectd"]["read_threads"],
    :write_queue_limit_high => node["collectd"]["write_queue_limit_high"],
    :write_queue_limit_low => node["collectd"]["write_queue_limit_low"],
    :collect_internal_stats => node["collectd"]["collect_internal_stats"],
    :plugins      => node["collectd"]["plugins"]
  )
  notifies :restart, "service[collectd]"
end

directory node["collectd"]["package"]["plugins_conf_dir"] do
  action :create
end

include_recipe 'collectd-ng::_service' do
  only_if { node["collectd"]["packages"].include?("collectd") }
end
