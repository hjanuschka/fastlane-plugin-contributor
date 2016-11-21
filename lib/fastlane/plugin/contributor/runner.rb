module Fastlane
  module Contributor
    class Runner
      def run(params)
        FastlaneCore::PrintTable.print_values(config: params,
                                           hide_keys: [],
                                               title: "Summary for fastlane-contributor #{Contributor::VERSION}")
         if params[:action] == "split_pr"
           Fastlane::Actions::SplitPrAction.run(params)
           return
         end
      end
    end
  end
end