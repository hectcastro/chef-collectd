service "collectd" do
  action [ :disable, :stop ]
end

execute "remove_collectd" do
  command "rm -rf #{node["collectd"]["dir"]}"
  action :run
end

include_recipe "collectd"

ruby_block "remove_recipe_collectd_recompile" do
  block { node.run_list.remove("recipe[collectd::recompile]") }
end
