module DateUtils
  
  class Week
    def initialize date = nil
      @date = date || Date.today
      @week = @date.cweek
    end

    def start_day
      Date.commercial(@date.year, @week, 1)
    end
    
    def end_day
      Date.commercial(@date.year, @week, 7)
    end

    def prev
      Week.new(@date - 1.week)
    end

    def next
      Week.new(@date + 1.week)
    end
  end
end
