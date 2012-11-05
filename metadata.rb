name              "collectd"
maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures collectd."
version           "0.0.3"
recipe            "collectd", "Installs and configures collectd"
recipe            "collectd::attribute_driven", "Installs collectd plugins via node attributes"

%w{ build-essential }.each do |d|
  depends d
end

%w{ ubuntu }.each do |os|
    supports os
end
