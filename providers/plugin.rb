use_inline_resources

action :create do
  template ::File.join(node["collectd"]["config_dir"][node['collectd']['install_method']], "#{new_resource.name}.conf") do
    owner "root"
    group "root"
    mode "644"
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :name   => new_resource.name,
      :config => new_resource.config
    )
  end
end

action :delete do
  file "#{new_resource.name} :delete #{node["collectd"]["config_dir"][node['collectd']['install_method']]}/#{new_resource.name}.conf}" do
    path ::File.join(node["collectd"]["config_dir"][node['collectd']['install_method']], "#{new_resource.name}.conf")
    action :delete
  end
end
