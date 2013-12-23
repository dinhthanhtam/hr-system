class PickupListUser < Base
	belongs_to :user
	belongs_to :pickup_list
	validates :user_id, uniqueness: { scope: :pickup_list_id }
  after_create :send_notice

  def send_notice
    UserMailer.delay.notice_user_added_to_pickup_list(user) 
  end

private
	class << self
    def updatable_attrs
      [:id, :pickup_list_id, :user_id]
    end
  end
end
