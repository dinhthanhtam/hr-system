class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :report_category_id
      t.integer :user_id
      t.text :title
      t.text :description
      t.date :report_date
      t.string :support_users
      t.timestamps
    end
  end
end
