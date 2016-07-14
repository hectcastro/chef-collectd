if node['platform_family'] == 'solaris2'

  ark 'collectd' do
    url node["collectd"]["url"]
    path Chef::Config[:file_cache_path]
    action :put
  end

  template "#{Chef::Config[:file_cache_path]}/collectd/build-collectd.sh" do
    source 'build-collectd.sh.erb'
    mode '0755'
    variables(
      solaris_studio: "/opt/solarisstudio#{node['collectd']['solaris']['studio_version']}/bin",
      ld_library_paths: '/lib/64:/usr/lib/64:/usr/sfw/lib/64:/lib:/usr/lib:/usr/sfw/lib',
      cflags: '"-fast -mt -m64 -DSOLARIS2=11"',
      dir: node["collectd"]["dir"]
    )
    action :create
  end

  execute 'build and install collectd on Solaris' do
    cwd "#{Chef::Config[:file_cache_path]}/collectd"
    command './build-collectd.sh'
    not_if "#{node["collectd"]["dir"]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
  end

else
  remote_file "#{Chef::Config[:file_cache_path]}/collectd-#{node["collectd"]["version"]}.tar.gz" do
    source node["collectd"]["url"]
    checksum node["collectd"]["checksum"]
    action :create_if_missing
  end

  bash "install-collectd-on-linux" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOH
      tar -xzf collectd-#{node["collectd"]["version"]}.tar.gz
      (cd collectd-#{node["collectd"]["version"]} && ./configure --prefix=#{node["collectd"]["dir"]} && make && make install)
    EOH
    not_if "#{node["collectd"]["dir"]}/sbin/collectd -h 2>&1 | grep #{node["collectd"]["version"]}"
  end
end
