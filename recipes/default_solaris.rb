
include_recipe "build-essential"	

remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}.tar.gz" do
  source node["collectd"]["url"]
  checksum node["collectd"]["checksum"]
  action :create_if_missing
end

bash "extract-collectd" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    /usr/sfw/bin/gtar -xvf collectd-#{node["collectd"]["version"]}.tar.gz
  EOH
end

cookbook_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}/src/collectd-tg.c" do
  source 'collectd/collectd-tg.c'
  mode '0755'
  action :create
end

bash "install-collectd" do
  cwd "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}"
  code <<-EOH
    export CFLAGS='-m64 -DSOLARIS2=11'
    ./configure
    make all install
  EOH
end