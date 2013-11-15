require 'spec_helper'

describe User do
  before do
    User.destroy_all
  end

  let(:user) { FactoryGirl.create :user }

  describe "reported?" do
    context "Had been write report in week" do
      before do
        report_category = FactoryGirl.create :report_category
        FactoryGirl.create(:report, user_id: user.id, report_category_id: report_category.id,
                                          week: Date.today.cweek, year: Date.today.year)
      end
      it { user.reported?.should be_true }
    end
    context "Hadn't been write report in week" do
      before do
        Report.where(week: Date.today.cweek).try(:destroy_all)
      end
      it { user.reported?.should be_false }
    end
  end

  describe "#is_staff?"do
    context "User is staff" do
      before do
        user.update_attributes(position: "Staff")
      end
      it { user.is_staff?.should be_true }
    end
    context "User isn't staff" do
      before do
        user.update_attributes(position: "Leader")
      end
      it { user.is_staff?.should be_false }
    end
  end

  describe "#is_leader?"do
    context "User is leader" do
      before do
        user.update_attributes(position: "Leader")
      end
      it { user.is_leader?.should be_true }
    end
    context "User is subleader" do
      before do
        user.update_attributes(position: "Subleader")
      end
      it { user.is_leader?.should be_true }
    end
    context "User isn't leader or subleader" do
      before do
        user.update_attributes(position: "Staff")
      end
      it { user.is_leader?.should be_false }
    end
  end

  describe "#is_manager?"do
    context "User is manager" do
      before do
        user.update_attributes(position: "Manager")
      end
      it { user.is_manager?.should be_true }
    end
    context "User is submanager" do
      before do
        user.update_attributes(position: "Submanager")
      end
      it { user.is_manager?.should be_true }
    end
    context "User isn't manager or submanager" do
      before do
        user.update_attributes(position: "Staff")
      end
      it { user.is_manager?.should be_false }
    end
  end
end
