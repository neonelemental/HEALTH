require "rails_helper"

describe Health::NotificationsMailer, type: :mailer do
  describe "alert" do
    let(:run) { FactoryBot.create(:health_check_run) }
    let(:results) { [MockResult.create, MockResult.create] }
    let(:mail) { Health::NotificationsMailer.with(run: run, results: results).alert }

    it "renders the headers" do
      expect(mail.to).to eq [Health.configuration.notifications_to]
      expect(mail.from).to eq ["healthchecks@upstart.com"]
      expect(mail.subject).to eq "#{run.health_check_name} failed!"
      expect(mail.body.encoded).to include(results.first.id.to_s)
      expect(mail.body.encoded).to include(results.second.id.to_s)
    end
  end
end