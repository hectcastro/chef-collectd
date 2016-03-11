include_recipe "build-essential"

remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}.tar.gz" do
  source node["collectd"]["url"]
  checksum node["collectd"]["checksum"]
  action :create_if_missing
end

bash "install-collectd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzf collectd-#{node["collectd"]["version"]}.tar.gz
    (cd collectd-#{node["collectd"]["version"]} && ./configure --prefix=#{node["collectd"]["install_dir"]} && make && make install)
  EOH
  not_if "#{node["collectd"]["install_dir"]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
end

template "/etc/init.d/collectd" do
  mode "0744"
  case node["platform_family"]
  when "rhel"
    source "collectd.init-rhel.erb"
  else
    source "collectd.init.erb"
  end
  variables(
    :dir => node["collectd"]["install_dir"]
  )
  notifies :restart, "service[collectd]"
  not_if { node["init_package"] == "systemd" }
end

template "/usr/lib/systemd/system/collectd.service" do
  mode "0644"
  variables(
    :dir => node["collectd"]["install_dir"]
  )
  notifies :restart, "service[collectd]"
  only_if { node["init_package"] == "systemd" }
end

directory "#{node["collectd"]["config_dir"]["source"]}/etc/conf.d" do
  action :create
  recursive true
end
