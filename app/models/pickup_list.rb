class PickupList < Base
	after_create :set_owner
	has_many :pickup_list_users
	has_many :users, through: :pickup_list_users

	accepts_nested_attributes_for :pickup_list_users, allow_destroy: true, reject_if: :all_blank

	def set_owner
		self.pickup_list_users.create user_id: self.create_user_id
	end

private
	class << self
    def updatable_attrs
      [:name, :description, :create_user_id,
        pickup_list_users_attributes: [:id, :user_id, :pickup_list_id]]
    end
  end
end