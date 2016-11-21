describe Fastlane::Actions::ContributorAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The contributor plugin is working!")

      Fastlane::Actions::ContributorAction.run(nil)
    end
  end
end
