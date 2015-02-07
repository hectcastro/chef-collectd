actions :create

attribute :name,             :kind_of => String, :name_attribute => true
attribute :template,         :kind_of => String, :default => "python-plugin.conf.erb"
attribute :cookbook,         :kind_of => String, :default => "collectd"
attribute :typesdb,          :kind_of => String, :default => ""
attribute :config,           :kind_of => Hash,   :default => {}
attribute :module_config,    :kind_of => Hash,   :default => {}

def initialize(*args)
  super
  @action = :create
end
