class CreateSupportUsers < ActiveRecord::Migration
  def change
    create_table :support_users do |t|
      t.integer :report_id
      t.integer :user_id
      t.timestamps
    end
  end
end
