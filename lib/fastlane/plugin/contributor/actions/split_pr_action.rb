module Fastlane
  module Actions
    class SplitPrAction < Action
      def self.run(params)
        # ensure git status is clean
        other_action.ensure_git_status_clean
        UI.important("Resetting to #{params[:base_branch]}")
        do_command("git reset #{params[:base_branch]}")

        seperated_prs = []
        `git status -u -s --porcelain`.split("\n").each do | l |
          entry = l.split(" ")
          file_name = entry[1]
          module_info = file_name.split("/")
          mod = module_info.first
          seperated_prs << mod
        end
        
        current_branch=other_action.git_branch
        
        created_branches = []
        seperated_prs.each do | m, idx |
          m_branch = "#{current_branch}_#{m}"
          created_branches << m_branch
          do_command("git checkout -B #{m_branch}")
          # unstage all
          do_command("git reset")
          other_action.git_add(path: "#{File.expand_path(m)}/")
          do_command("git commit -m 'Split PR commit'")
          other_action.push_to_git_remote(force: true)
          

          git_remote=`git remote get-url origin`.gsub!("git@github.com:", "https://github.com/").gsub!(".git", "").chomp
          subject = "[#{m}] New PR #{idx}/#{seperated_prs.length}"
          body = "This is #{idx}/#{seperated_prs.length}"
          do_command("open '#{git_remote}/compare/#{m_branch}?expand=1&body=#{URI.escape(body)}&title=#{URI.escape(subject)}'")
          do_command("git checkout #{current_branch}")
          do_command("git reset --hard #{current_branch}")
        end
        
        
      end
      def self.do_command(cmd)
        FastlaneCore::CommandExecutor.execute(command: cmd,
                                            print_all: true,
                                        print_command: true)
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
