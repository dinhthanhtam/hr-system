class AddFixedToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :fixed, :boolean
  end
end
