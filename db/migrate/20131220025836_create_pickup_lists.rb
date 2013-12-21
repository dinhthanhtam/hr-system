class CreatePickupLists < ActiveRecord::Migration
  def change
    create_table :pickup_lists do |t|
      t.string :name
      t.string :description
      t.integer :create_user_id
      t.timestamps
    end
  end
end
