class AddMonOfWeekToCost < ActiveRecord::Migration
  def change
    remove_column :costs, :week
    remove_column :costs, :year
    add_column :costs, :mon_of_week, :date
  end
end
