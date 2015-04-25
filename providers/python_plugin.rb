use_inline_resources

action :create do
  template ::File.join(node["collectd"]["plugins_conf_dir"], "#{new_resource.name}.conf") do
    owner "root"
    group "root"
    mode "644"
    source new_resource.template
    cookbook new_resource.cookbook
    variables(
      :name   => new_resource.name,
      :typesdb => new_resource.typesdb,
      :config => new_resource.config,
      :module_config => new_resource.module_config
    )
  end
end
