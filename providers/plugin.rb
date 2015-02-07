action :create do
  template ::File.join(node["collectd"]["plugins_conf_dir"], "#{new_resource.name}.conf") do
    owner "root"
    group "root"
    mode "644"
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :name   => new_resource.name,
      :config => new_resource.config
    )
    notifies :restart, "service[collectd]"
  end
  new_resource.updated_by_last_action(true)
end

action :delete do
  file "#{new_resource.name} :delete #{node["collectd"]["plugins_conf_dir"]}/#{new_resource.name}.conf}"
    path ::File.join(node["collectd"]["plugins_conf_dir"], "#{new_resource.name}.conf") do
    action :delete
    notifies :restart, "service[collectd]"
  end
  new_resource.updated_by_last_action(true)
end
