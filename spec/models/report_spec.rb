require 'spec_helper'

describe Report do
  before do
    User.destroy_all
    Report.destroy_all
  end

  let(:user) { FactoryGirl.create :user }
  let(:report_category) { FactoryGirl.create :report_category }
  let(:report) { FactoryGirl.create(:report, user_id: user.id, report_category_id: report_category.id) }

  subject { report }

  describe "#in_current_week?" do
    context "week is current week" do
      before do
        report.update_attributes(week: Date.today.cweek, year: Date.today.year)
      end
      it { report.in_current_week?.should be_true }
    end

    context "week isn't current week" do
      before do
        report.update_attributes(week: Date.today.cweek - 1, year: Date.today.year)
      end
      it { report.in_current_week?.should be_false }
    end
  end

  describe "#is_stickied?" do
    context "User Report added sticky" do
      before do
        FactoryGirl.create(:sticky, user_id: user.id, report_id: report.id)
      end
      it { report.is_stickied?(user.id).should be_true }
    end
    context "Report hasn't add sticky" do
      before do
        user_2 = FactoryGirl.create(:user, email: "test@test.com")
        FactoryGirl.create(:sticky, user_id: user_2.id, report_id: report.id)
      end
      it { report.is_stickied?(user.id).should be_false }
    end
  end
end
