require 'fastlane/plugin/contributor/version'

module Fastlane
  module Contributor
    # Return all .rb files inside the "actions" and "helper" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,helper}/*.rb', File.dirname(__FILE__))]
    end
  end
end


require 'fastlane'
# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::Contributor.all_classes.each do |current|
  require current
end

require 'fastlane/plugin/contributor/options'
require 'fastlane/plugin/contributor/runner'
require 'fastlane/plugin/contributor/commands_generator'
