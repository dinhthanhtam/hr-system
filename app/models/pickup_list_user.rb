class PickupListUser < Base
	belongs_to :user
	belongs_to :pickup_list
	validates :user_id, uniqueness: { scope: :pickup_list_id }

private
	class << self
    def updatable_attrs
      [:id, :pickup_list_id, :user_id]
    end
  end
end
