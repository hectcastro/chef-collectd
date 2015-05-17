# For ChefSpec LWRP custom matchers:
# https://github.com/sethvargo/chefspec#packaging-custom-matchers
if defined?(ChefSpec)
  def create_collectd_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:collectd_plugin, :create, name)
  end

  def delete_collectd_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:collectd_plugin, :delete, name)
  end

  def create_collectd_python_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:collectd_plugin, :create, name)
  end

  def delete_collectd_python_plugin(name)
    ChefSpec::Matchers::ResourceMatcher.new(:collectd_plugin, :delete, name)
  end
end
