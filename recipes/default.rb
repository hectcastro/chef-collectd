if node["platform_family"] == "rhel" && node["platform_version"].to_i > 5
  %w{ perl-ExtUtils-Embed perl-ExtUtils-MakeMaker }.each do |pkg|
    package pkg
  end
end

include_recipe "collectd-ng::plugins" unless node["collectd"]["plugins"].empty?

include_recipe "collectd-ng::install_from_#{node['collectd']['install_method']}"

template "#{node["collectd"]["config_dir"][node['collectd']['install_method']]}/collectd.conf" do
  mode "0644"
  source "collectd.conf.erb"
  variables(
    :name         => node["collectd"]["name"],
    :fqdnlookup   => node["collectd"]["fqdnlookup"],
    :dir          => node["collectd"]["config_dir"][node['collectd']['install_method']],
    :interval     => node["collectd"]["interval"],
    :read_threads => node["collectd"]["read_threads"],
    :write_queue_limit_high => node["collectd"]["write_queue_limit_high"],
    :write_queue_limit_low => node["collectd"]["write_queue_limit_low"],
    :collect_internal_stats => node["collectd"]["collect_internal_stats"],
    :plugins      => node["collectd"]["plugins"]
  )
  notifies :restart, "service[collectd]"
end

include_recipe 'collectd-ng::_service'
