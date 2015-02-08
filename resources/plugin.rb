actions :create, :delete
default_action :create

attribute :name,      :kind_of => String, :name_attribute => true
attribute :template,  :kind_of => String, :default => "plugin.conf.erb"
attribute :cookbook,  :kind_of => String, :default => "collectd"
attribute :config,    :kind_of => Hash,   :default => {}

def initialize(*args)
  super
  @action = :create
end
