class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.integer :parent_id
      t.string :url
      t.boolean :is_publish
      t.string :state
      t.date :start_date
      t.date :due_date
      t.date :end_date

      t.timestamps
    end
  end
end
