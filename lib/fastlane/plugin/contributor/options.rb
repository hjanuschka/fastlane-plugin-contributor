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
                                                                  type: String),
                                                                  FastlaneCore::ConfigItem.new(key: :base_repo,
                                                                                                                      env_name: "FL_CONTRIB_BASE_REPO",
                                                                                                                   description: "BASE_REPO",
                                                                                                                      optional: false,
                                                                                                                      default_value: "fastlane",
                                                                                                                      is_string: true,
                                                                                                                          type: String),  
                                                                  FastlaneCore::ConfigItem.new(key: :username,
                                                                                                                      env_name: "FL_CONTRIB_USER",
                                                                                                                   description: "Contrib Username",
                                                                                                                      optional: false,
                                                                                                                      is_string: true,
                                                                                                                          type: String)  
          
        ]
      end
    end
  end
end