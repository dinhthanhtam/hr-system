class CreatePayslips < ActiveRecord::Migration
  def change
    create_table :payslips do |t|
      t.integer :user_id
      t.string :payslip
      t.string :paymonth

      t.timestamps
    end
  end
end
