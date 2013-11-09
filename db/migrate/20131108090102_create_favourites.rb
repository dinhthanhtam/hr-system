class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :report_id
      t.integer :user_id
      t.timestamps
    end
  end
end
