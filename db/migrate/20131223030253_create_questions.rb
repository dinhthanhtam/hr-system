class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :name
      t.text :content
      t.boolean :evaluation
      t.string :checkpoint_type
      t.timestamps
    end
  end
end