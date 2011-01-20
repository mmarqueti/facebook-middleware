
class Fixnum

  def minute
    self * 60
  end

  def minutes
    minute
  end

  def hour
    self.minutes * 60
  end

  def hours
    hour
  end

  def day
    self.hours * 24
  end

  def days
    day
  end

  def week
    days * 7
  end

  def weeks
    week
  end

end
