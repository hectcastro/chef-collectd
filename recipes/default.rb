bash "install-collectd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xzf collectd-#{node["collectd"]["version"]}.tar.gz
    (cd collectd-#{node["collectd"]["version"]} && ./configure --prefix=#{node["collectd"]["dir"]} && make && make install)
  EOH
  action :nothing
  not_if "#{node["collectd"]["dir"]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
end

remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}.tar.gz" do
  source node["collectd"]["url"]
  checksum node["collectd"]["checksum"]
  notifies :run, resources(:bash => "install-collectd"), :immediately
end

template "/etc/init.d/collectd" do
  mode "0766"
  source "collectd.init.erb"
  variables(
    :dir => node["collectd"]["dir"]
  )
  notifies :restart, "service[collectd]"
end

template "#{node["collectd"]["dir"]}/etc/collectd.conf" do
  mode "0644"
  source "collectd.conf.erb"
  variables(
    :name         => node["collectd"]["name"],
    :dir          => node["collectd"]["dir"],
    :interval     => node["collectd"]["interval"],
    :read_threads => node["collectd"]["read_threads"],
    :plugins      => node["collectd"]["plugins"]
  )
  notifies :restart, "service[collectd]"
end

directory "#{node["collectd"]["dir"]}/etc/conf.d" do
  action :create
end

service "collectd" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
