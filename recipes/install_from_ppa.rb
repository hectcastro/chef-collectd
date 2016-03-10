# FIXME No RHEL support

include_recipe 'apt'

apt_repository "llnw_ppa" do
  uri "http://ppa.launchpad.net/llnw/collectd/ubuntu"
  components ["main"]
  distribution node['lsb']['codename']
  keyserver "keyserver.ubuntu.com"
  key "01E811D4"
end

package "collectd" do
  action :install
  version node['collectd']['version']
end
