class RemoveSupportUsersColumn < ActiveRecord::Migration
  def change
    remove_column :reports, :support_users
  end
end
