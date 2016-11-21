require 'fastlane_core'
require 'credentials_manager'

module Fastlane
  module Contributor
    class Options
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :base_branch,
                                  env_name: "FL_CONTR_BASE_BRANCH",
                               description: "Reset to this Branch",
                                  optional: false,
                             default_value: "origin/master",
                                      type: String),
          FastlaneCore::ConfigItem.new(key: :action,
                                                              env_name: "FL_CONTR_ACTION",
                                                           description: "Action",
                                                              optional: false,
                                                         default_value: "split_pr",
                                                                  type: String)                                      
          
        ]
      end
    end
  end
end