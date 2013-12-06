class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :user_id
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
