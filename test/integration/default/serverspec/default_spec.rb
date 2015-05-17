require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe 'default' do
  it 'service collectd should be running' do
    expect(service 'collectd').to be_enabled
    expect(service 'collectd').to be_running
  end
  it 'creates attribute-driven plugins' do
    plugins = %w(cpu df disk interface memory swap syslog)
    plugins.each do |plugin|
      expect(file "/opt/collectd/etc/conf.d/#{plugin}.conf").to be_file
    end
  end
  describe file('/opt/collectd/etc/conf.d/write_graphite.conf') do
    it { should be_a_file }
    its(:content) { should include 'Host "localhost"' }
    its(:content) { should include 'Port 2003' }
    its(:content) { should include 'Prefix "collectd."' }
  end
end
