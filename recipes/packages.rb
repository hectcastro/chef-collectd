node["collectd"]["packages"].each do |pkg|
  package pkg
end

include_recipe 'collectd-ng::_service' do
  only_if { node["collectd"]["packages"].include?("collectd") }
end
