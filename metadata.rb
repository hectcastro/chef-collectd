name              "collectd-ng"
maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures collectd."
version           "2.2.0"
recipe            "collectd", "Installs and configures collectd"
recipe            "collectd::plugins", "Installs collectd plugins via node attributes"
recipe            "collectd::packages", "Installs collectd via packages"
recipe            "collectd::recompile", "Attempts to recompile collectd"

%w{ amazon centos fedora redhat scientific ubuntu }.each do |os|
  supports os
end
