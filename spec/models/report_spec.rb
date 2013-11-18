require 'spec_helper'

describe Report do
  before do
    User.destroy_all
    Report.destroy_all
  end
  let(:role) { FactoryGirl.create :role }
  let(:user) { FactoryGirl.create(:user, user_roles_attributes: [{ role_id: role.id }]) }
  let(:report_category) { FactoryGirl.create :report_category }
  let(:report) { FactoryGirl.create(:report, user_id: user.id, report_category_id: report_category.id,
                                    title: "Title", description: "Description", report_date: Date.today) }

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
        user_2 = FactoryGirl.create(:user, email: "test@test.com", user_roles_attributes: [{ role_id: 1 }])
        FactoryGirl.create(:sticky, user_id: user_2.id, report_id: report.id)
      end
      it { report.is_stickied?(user.id).should be_false }
    end
  end

  describe "#valid_report_date" do
    context "When report_date valid" do
      before do
        report.update_attributes(report_date: Date.today, week: Date.today.cweek - 1, year: Date.today.year)
      end
      it { should be_valid }
    end
    context "When report invalid" do
      context "Not in current_week" do
        before do
          report.update_attributes(report_date: Date.today - 6, week: Date.today.cweek - 1, year: Date.today.year)
        end
        it { should_not be_valid }
      end
      context "Report_date out of date" do
        before do
          report.update_attributes(report_date: Date.today + 1, week: (Date.today + 1).cweek, year: Date.today.year)
        end
        it { should_not be_valid }
      end
    end
  end
end
