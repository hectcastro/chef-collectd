include_recipe "build-essential"

if node["platform_family"] == "rhel" && node["platform_version"].to_i > 5
  %w{ perl-ExtUtils-Embed perl-ExtUtils-MakeMaker }.each do |pkg|
    package pkg
  end
end

if node['platform_family'] == 'solaris2'
  package 'libtool/libltdl'
  package 'developer-gnu'

  #==========================================
  # Installing Solaris Studio
  #==========================================

  if File.readable?('/etc/chef/encrypted_data_bag_secret')
    secret = Chef::EncryptedDataBagItem.load_secret('/etc/chef/encrypted_data_bag_secret')
    oracle_key_cert = Chef::EncryptedDataBagItem.load(node['collectd']['solaris']['oracle_key_databag'], node['collectd']['solaris']['oracle_key_databag_entry'], secret)
  else
    oracle_key_cert = data_bag_item('oracle_key', 'not_real')
  end

  file 'oracle certificate' do
    path "#{node['collectd']['solaris']['oracle_key_directory']}/pkg.oracle.com.certificate.pem"
    mode '0644'
    content oracle_key_cert['cert']
  end

  file 'oracle key' do
    path "#{node['collectd']['solaris']['oracle_key_directory']}/pkg.oracle.com.key.pem"
    mode '0600'
    content oracle_key_cert['key']
  end

  execute 'sets up Solaris Studio package repository' do
    command "pkg set-publisher -k #{node['collectd']['solaris']['oracle_key_directory']}/pkg.oracle.com.key.pem -c #{node['collectd']['solaris']['oracle_key_directory']}/pkg.oracle.com.certificate.pem -G \"*\" -g https://pkg.oracle.com/solarisstudio/release solarisstudio"
  end

  studio_version = node['collectd']['solaris']['studio_version']
  package "solarisstudio-#{solaris_package_version_to_name(studio_version)}"

end
