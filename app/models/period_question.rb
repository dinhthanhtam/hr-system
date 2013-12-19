class PeriodQuestion < ActiveRecord::Base
  belongs_to :checkpoint_period
  belongs_to :checkpoint_question
end
