class AddDescriptionToCheckpointPeriod < ActiveRecord::Migration
  def change
  	add_column :checkpoint_periods, :description, :text
  end
end
