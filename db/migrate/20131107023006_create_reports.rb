class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :report_category_id
      t.integer :user_id
      t.text :description
      t.date :report_date
      t.integer :week
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
