
class Month

  attr_reader :month_number
  attr_reader :dates

  def initialize month_number
    @month_number = month_number
  end

  def dates options = nil

    if options.nil?
      year = Time.now.year
    else
      year = options[:year]
    end

    @dates = Array.new

    1.upto(31) do |n|
      time = Time.local(year, @month_number, n)
      @dates << time if time.month.eql? @month_number
    end

    return @dates
  end
end

class Week

  attr_reader :week_number
  attr_reader :dates

  def initialize week_number
    @week_number = week_number

    @@year_dates ||= Hash.new
  end

  def dates options = nil

    if options.nil?
      year = Time.now.year
    else
      year = options[:year]
    end

    unless @@year_dates.key? year

      @@year_dates.update year => []

      1.upto(12) do |month_number|
        1.upto(31) do |day_number|
          time = Time.local(year, month_number, day_number)
          if time.month.eql? month_number
            @@year_dates[year] << time
          end
        end
      end

    end

    @dates = Array.new

    week_s = @week_number.to_s

    for date in @@year_dates[year]
      @dates << date if date.strftime("%U").eql? week_s
    end

    return @dates
  end
end

class Fixnum
  def month_generate
    Month.new(self)
  end

  def week_generate
    Week.new(self)
  end
end

