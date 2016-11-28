module Fastlane
  module Helper
    class ContributorHelper
      attr_accessor :client
      def client
        @client ||= Octokit::Client.new(access_token: ENV["GITHUB_API_TOKEN"])
      end
    end
  end
end