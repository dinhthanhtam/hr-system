class DateRanger
  DAYS = "days"
  WEEKS = "weeks"
  MONTHS = "months"

  attr_reader :years, :months, :weeks, :days

  def initialize min_date = nil, max_date = nil, type = nil
    @type = type
    @years = []
    @months = []
    @weeks = []
    @days = []
    date = min_date
    while date <= max_date
      @years << date.year unless @years.include? date.year
      @months << [date.month, date.year] unless @months.include? [date.month, date.year]
      unless @weeks.include? [get_week_of_years(date), get_month_of_years(date), get_year_of_weeks(date)]
        @weeks << [get_week_of_years(date), get_month_of_years(date), get_year_of_weeks(date)]
      end
      unless @days.include? [date.day, date.month, date.year]
        @days << [date.day, date.month, date.year]
      end
      date += 1
    end
  end

  def thursday_in_week date
    date.sunday? ? (date - 3) : (date + 4 - date.wday)
  end

  def get_week_of_years date
    date.cweek
  end

  def get_month_of_years date
    thursday_in_week(date).month
  end

  def get_year_of_weeks date
    thursday_in_week(date).year
  end

  def years_and_length array
    years_length = []
    @years.each do |year|
      length = array.count { |x| x.last == year }
      years_length << [year, length]
    end
    years_length
  end

  def month_and_length array
    month_length = []
    @months.each do |month|
      length = array.count { |x| [x[x.length - 2], x[x.length - 1]] == month }
      month_length << [month[0], length]
    end
    month_length
  end

  def get_years_and_length
    case @type
    when WEEKS
      years_and_length @weeks
    when MONTHS
      years_and_length @months
    else
      years_and_length @days
    end
  end

  def get_months_and_length
    case @type
    when WEEKS
      month_and_length @weeks
    when MONTHS
      month_and_length @months
    else
      month_and_length @days
    end
  end

  def get_weeks_and_length
    @weeks.map { |week| [week[0], 1] }
  end

  def get_days_and_length
    @days.map { |day| [day[0], 1] }
  end

  def get_years_months_length
    [get_years_and_length, 
      get_months_and_length.map { |months_length| [Date::MONTHNAMES[months_length[0]], months_length[1]] }]
  end

  def get_titles_array
    case @type
    when WEEKS
      get_years_months_length << get_weeks_and_length
    when MONTHS
      [get_years_and_length, get_months_and_length]
    else
      get_years_months_length << get_days_and_length
    end
  end
end
