if node["platform_family"] == "rhel" && node["platform_version"].to_i > 5
  %w{ perl-ExtUtils-Embed perl-ExtUtils-MakeMaker }.each do |pkg|
    package pkg
  end
end

if node["collectd"]["plugins"]
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
  end

  plugin_support_packages.each do |pkg|
    package pkg
  end
end

include_recipe "install_from_#{node['collectd']['install_method']}"

template "/etc/init.d/collectd" do
  mode "0744"
  case node["platform_family"]
  when "rhel"
    source "collectd.init-rhel.erb"
  else
    source "collectd.init.erb"
  end
  variables(
    :dir => node["collectd"]["dir"]
  )
  notifies :restart, "service[collectd]"
  not_if { node["init_package"] == "systemd" }
end

template "/usr/lib/systemd/system/collectd.service" do
  mode "0644"
  variables(
    :dir => node["collectd"]["dir"]
  )
  notifies :restart, "service[collectd]"
  only_if { node["init_package"] == "systemd" }
end

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
    :plugins      => node["collectd"]["plugins"]
  )
  notifies :restart, "service[collectd]"
end

directory "#{node["collectd"]["dir"]}/etc/conf.d" do
  action :create
end

include_recipe 'collectd-ng::_service'
