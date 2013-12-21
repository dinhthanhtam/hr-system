class CreatePickupListUsers < ActiveRecord::Migration
  def change
    create_table :pickup_list_users do |t|
      t.belongs_to :user
      t.belongs_to :pickup_list
      t.timestamps
    end
  end
end
