if node['platform_family'] == 'solaris2'
  directory node['collectd']['solaris']['manifest_directory'] do
    action :create
  end

  template "#{node["collectd"]["dir"]}/collectd-control.sh" do
    source 'collectd-smf-control.sh.erb'
    variables(
      name: 'collectd',
      daemon_path: "#{node["collectd"]["dir"]}/sbin/collectd",
      conf_path: "#{node["collectd"]["dir"]}/etc/collectd.conf"
    )
  end

  template "#{node['collectd']['solaris']['manifest_directory']}/collectd.xml" do
    source 'collectd-solaris-manifest.xml.erb'
    variables(
      name: 'application/collectd',
      script: "#{node['collectd']['dir']}/collectd-control.sh"
    )
    notifies :run, 'execute[load collectd manifest]', :immediately
  end

  smf_standard_locations = [
    '/lib/svc/manifest',
    '/var/svc/manifes'
  ]

  load_manifest_command = smf_standard_locations.any? { |i| node['collectd']['solaris']['manifest_directory'].start_with? i } ? 'svcadm restart svc:/system/manifest-import' : "svccfg import #{node['collectd']['solaris']['manifest_directory']}/collectd.xml"

  execute 'load collectd manifest' do
    action :nothing
    command load_manifest_command
    notifies :restart, 'service[collectd]'
  end

else
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
end

service "collectd" do
  supports :status => true, :restart => true, :reload => true
  retries 30
  retry_delay 4
  action [ :enable, :start ]
end
