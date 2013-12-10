class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :hometown, :string
    add_column :users, :residential_address, :string
    add_column :users, :tel, :string
    add_column :users, :gender, :string
    add_column :users, :marital_status, :string
    add_column :users, :foreign_language, :string
    add_column :users, :contract_type, :string
    add_column :users, :university, :string
    add_column :users, :identity_id, :string
    add_column :users, :license_plate, :string
    add_column :users, :ticket, :string

    add_column :users, :birthday, :date
    add_column :users, :join_date, :date
    add_column :users, :out_date, :date
  end
end
