require 'spec_helper'

describe 'collectd::default' do
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
          ChefSpec::SoloRunner.new(platform: platform, version: version, file_cache_path: '/var/chef/cache').converge described_recipe
        end
        before do
          stub_command('/opt/collectd/sbin/collectd -h 2>&1 | grep 5.4.1').and_return(true)
        end
        it 'enables and starts collectd' do
          expect(chef_run).to enable_service 'collectd'
          expect(chef_run).to start_service 'collectd'
        end
      end
    end
  end
end
