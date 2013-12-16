class Feedback < Base

  belongs_to :user

  state_machine :fixed, initial: :false do
    event :set_fixed do
      transition :false => :true
    end
  end
end
