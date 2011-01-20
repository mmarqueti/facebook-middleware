
class Time

  def change_my args
    args_desired = [:year, :month, :day, :hour, :min, :sec, :usec]
    raise ArgumentError, "This argument is not a hash object" unless args.instance_of? Hash
    raise ArgumentError, "This hash is empty" if args.empty?

    all_keys_are_valid = nil
    args.each_key { |key| all_keys_are_valid = args_desired.include?(key) }

    raise ArgumentError, "One of the keys is not valid" unless all_keys_are_valid
    
    ttc = { #ttc means time to change
          :year  => self.year,
          :month => self.month,
          :day   => self.day,
          :hour  => self.hour,
          :min   => self.min,
          :sec   => self.sec,
          :usec  => self.usec
          }

    args.each { |key, value| ttc[key] = value }

    return Time.mktime(ttc[:year], ttc[:month], ttc[:day], ttc[:hour], ttc[:min], ttc[:sec], ttc[:usec])
  end

  def self.new! args = nil
    args_desired = [:year, :month, :day]

    raise ArgumentError, "Invalid argument, use a hash or nil object" unless [NilClass, Hash].include? args.class
    raise ArgumentError, "This hash is empty" if args.instance_of?(Hash) and args.empty?

    all_keys_are_valid = nil
    args.each_key { |key| all_keys_are_valid = args_desired.include?(key) }        unless args.nil?
    raise ArgumentError, "One of the keys is not valid" unless all_keys_are_valid  unless args.nil?
    
    now = Time.now
    
    return Time.mktime(now.year, now.month, now.day, now.hour) if args.nil?

    t = { #t means time
      :year  => now.year,
      :month => now.month,
      :day   => now.day
    }

    args.each { |key, value| t[key] = value }

    return Time.mktime(t[:year], t[:month], t[:day])
  end

  def self.new! args = nil
    args_desired = [:year, :month, :day]

    raise ArgumentError, "Invalid argument, use a hash or nil object" unless [NilClass, Hash].include? args.class
    raise ArgumentError, "This hash is empty" if args.instance_of?(Hash) and args.empty?

    all_keys_are_valid = nil
    args.each_key { |key| all_keys_are_valid = args_desired.include?(key) }        unless args.nil?
    raise ArgumentError, "One of the keys is not valid" unless all_keys_are_valid  unless args.nil?
    
    now = Time.now
    
    return Time.mktime(now.year, now.month, now.day) if args.nil?

    t = { #t means time
      :year  => now.year,
      :month => now.month,
      :day   => now.day
    }

    args.each { |key, value| t[key] = value }

    return Time.mktime(t[:year], t[:month], t[:day])
  end

  
  def self.regress quantity_seconds = 0
    Time.now - quantity_seconds
  end
  
  def self.regress! quantity_seconds = 0
    Time.new! - quantity_seconds
  end
  
  def regress quantity_seconds = 0
    self - quantity_seconds
  end

  def sum quantity_seconds = 0
    self + quantity_seconds
  end
end

