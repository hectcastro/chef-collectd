require 'spec_helper'

describe 'collectd::attribute_driven' do
  platforms = {
    'ubuntu' => {
      'versions' => ['12.04', '14.04']
    },
    'centos' => {
      'versions' => ['6.5', '6.6']
    }
  }

  platforms.each do |platform, value|
    value['versions'].each do |version|
      context "on #{platform} #{version}" do
        let(:chef_run) do
          ChefSpec::SoloRunner.new(platform: platform, version: version, file_cache_path: '/var/chef/cache') do |node|
            node.set['collectd']['plugins'] = {
              'cpu' => {},
              'disk' => {},
              'interface' => {
                'config' => {
                  'Interface' => 'lo',
                  'IgnoreSelected' => true
                }
              },
              'memory' => {}
            }
          end.converge described_recipe
        end
        before do
          stub_command('/opt/collectd/sbin/collectd -h 2>&1 | grep 5.4.1').and_return(true)
        end
        it 'creates some plugins' do
          expect(chef_run).to create_collectd_plugin('cpu')
          expect(chef_run).to create_collectd_plugin('interface').with(
            'config' => {
              'Interface' => 'lo',
              'IgnoreSelected' => true
            }
          )
        end
      end
    end
  end
end
