class CreateStickies < ActiveRecord::Migration
  def change
    create_table :stickies do |t|
      t.integer :report_id
      t.integer :user_id
      t.timestamps
    end
  end
end
