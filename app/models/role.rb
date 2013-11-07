class Role < ActiveRecord::Base
  attr_accessible :name, :role_category_id

  belongs_to :role_category
end
