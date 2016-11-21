module Fastlane
  module Actions
    class SplitPrAction < Action
      def self.run(params)
        # ensure git status is clean
        other_action.ensure_git_status_clean
        UI.important("Resetting to #{params[:base_branch]}")
        FastlaneCore::CommandExecutor.execute(command: "git reset #{params[:base_branch]}",
                                          print_all: true,
                                      print_command: true
                                              )

        seperated_prs = []
        `git status -u -s --porcelain`.split("\n").each do | l |
          entry = l.split(" ")
          file_name = entry[1]
          module_info = file_name.split("/")
          mod = module_info.first
          seperated_prs << mod
        end
        
        current_branch=other_action.git_branch
        
        seperated_prs.each do | m |
          FastlaneCore::CommandExecutor.execute(command: "git checkout -B #{current_branch}_#{m}",
                                            print_all: true,
                                        print_command: true
                                                )
          other_action.git_add(path: "#{File.expand_path(m)}/")
          other_action.push_to_git_remote(force: true)
          FastlaneCore::CommandExecutor.execute(command: "git checkout #{current_branch}",
                                              print_all: true,
                                          print_command: true)
        end
        
      end

      def self.description
        "a"
      end

      def self.authors
        ["Helmut Januschka"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "a"
      end

      def self.available_options
        [
           FastlaneCore::ConfigItem.new(key: :base_branch,
                                   env_name: "FL_CONTR_BASE_BRANCH",
                                description: "Reset to this Branch",
                                   optional: false,
                              default_value: "origin/master",
                                       type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://github.com/fastlane/fastlane/blob/master/fastlane/docs/Platforms.md
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
