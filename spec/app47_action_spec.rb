describe Fastlane::Actions::App47Action do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The app47 plugin is working!")

      Fastlane::Actions::App47Action.run(nil)
    end
  end
end
