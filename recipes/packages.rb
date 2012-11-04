node["collectd"]["packages"].each do |pkg|
  package pkg
end

service "collectd" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  only_if { node["collectd"]["packages"].include?("collectd") }
end
