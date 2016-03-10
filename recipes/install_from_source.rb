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
    (cd collectd-#{node["collectd"]["version"]} && ./configure --prefix=#{node["collectd"]["dir"]} && make && make install)
  EOH
  not_if "#{node["collectd"]["dir"]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
end
