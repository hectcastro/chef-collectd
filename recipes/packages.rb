node["collectd"]["packages"].each do |pkg|
  package pkg
end

include_recipe 'collectd::_service' only_if { node["collectd"]["packages"].include?("collectd") }
