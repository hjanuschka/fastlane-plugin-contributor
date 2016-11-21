require 'commander'

HighLine.track_eof = false
module Fastlane
  module Contributor
    class CommandsGenerator
      include Commander::Methods
      UI = FastlaneCore::UI

      def self.start
        FastlaneCore::UpdateChecker.start_looking_for_update('fastlane-plugin-contributor')
        self.new.run
      ensure

        FastlaneCore::UpdateChecker.show_update_status('fastlane-plugin-contributor', Contributor::VERSION)
      end

      def run
        program :version, Contributor::VERSION
        program :description, "Contributor"
        program :help, 'Author', 'Helmut Januschka <helmut@januschka.com>'
        program :help, 'Website', 'https://fastlane.tools'
        program :help, 'GitHub', 'https://github.com/hjanuschka/fastlane-plugin-contributor'
        program :help_formatter, :compact

        global_option('--verbose') { $verbose = true }

        FastlaneCore::CommanderGenerator.new.generate(Contributor::Options.available_options)

        command :split_pr do |c|
          c.syntax = 'fastlane-contributor'
          c.description = Contributor::DESCRIPTION
          c.action do |args, options|
            params = FastlaneCore::Configuration.create(Contributor::Options.available_options, options.__hash__)
            params.load_configuration_file("Contributorfile")
            params[:action]="split_pr"
            Contributor::Runner.new.run(params)
          end
        end

        #default_command :run

        run!
      end
    end
  end
end