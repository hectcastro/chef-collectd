maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Installs and configures collectd."
version           "0.0.2"
recipe            "collectd", "Installs and configures collectd"
recipe            "collectd::attribute_driven", "Installs collectd plugins via node attributes"

%w{ ubuntu }.each do |os|
    supports os
end
