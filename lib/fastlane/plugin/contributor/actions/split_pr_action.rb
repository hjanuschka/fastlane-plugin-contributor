module Fastlane
  module Actions
    class SplitPrAction < Action
      def self.run(params)
        # ensure git status is clean
        repo_clean = `git status --porcelain`.empty?
        if repo_clean
          UI.success('Git status is clean, all good! 💪')
        else
          UI.user_error!("Git repository is dirty! Please ensure the repo is in a clean state by commiting/stashing/discarding all changes first.")
        end
        
        fork_remote="contributor-#{params[:username]}"
        
        remote_missing=`git remote get-url #{fork_remote}`.empty?
        if remote_missing
          do_command("git remote add #{fork_remote} git@github.com:#{params[:username]}/#{params[:base_repo]}.git")
        end
        
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
        
        current_branch=`git symbolic-ref HEAD --short 2>/dev/null`.strip
        
        created_branches = []
        seperated_prs.each do | m, idx |
          m_branch = "#{current_branch}_#{m}"
          created_branches << m_branch
          do_command("git checkout -B #{m_branch}")
          # unstage all
          do_command("git reset")
          do_command("git add #{File.expand_path(m)}/")
          do_command("git commit -m 'Split PR commit'")
          do_command("git push -u #{fork_remote}")

          
          subject = "[#{m}] New PR #{idx}/#{seperated_prs.length}"
          body = "This is #{idx}/#{seperated_prs.length}"
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
           Contributor::Options.available_options
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
