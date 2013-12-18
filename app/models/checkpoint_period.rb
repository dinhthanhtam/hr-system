class CheckpointPeriod < Base
  def toString
    "#{self.name}(#{self.start_date}~#{self.end_date})"
  end
end
