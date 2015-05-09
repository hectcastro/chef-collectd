require 'chefspec'
require 'chefspec/berkshelf'
require 'support/matchers'

at_exit { ChefSpec::Coverage.report! }
