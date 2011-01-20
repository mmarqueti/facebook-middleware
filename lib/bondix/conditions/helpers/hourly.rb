
require File.join(File.dirname(__FILE__), "..", "..", "time", "time")

module Hourly

  @@ranges_hourly = {:default => {:first_hour => 0, :last_hour => 23}}

  def self.create_range name, first_hour, last_hour, key_word
    if !(@@ranges_hourly.key? name)

      @@ranges_hourly.update(name => { :first_hour => first_hour, :last_hour => last_hour, :key_word => key_word})

    elsif @@ranges_hourly.key? name and @@ranges_hourly[:name][:key_word] != key_word

      @@ranges_hourly[name] = {:first_hour => first_hour, :last_hour => last_hour, :key_word => key_word}
      
    else
      puts "This range already exists! \n Use the method 'delete_range' to delete it"
    end
  end

  def self.delete_range name
    @@ranges_hourly.delete(name) unless name.eql? :default
  end

  def hourly opt
    range = (@@ranges_hourly[opt[:range]][:first_hour]..@@ranges_hourly[opt[:range]][:last_hour])
    raise ArgumentError, "This argument is not a hash"     unless opt.instance_of? Hash
    raise ArgumentError, "This hash not have the key hour" unless opt.key? :max_hour
    raise ArgumentError, "This hour is not in range"       unless range.to_a.include? opt[:max_hour]

    opt[:time] = Time.new! if opt[:time].nil?

    {:conditions => ["created_at BETWEEN ? AND ?", opt[:time].change_my(:hour => range.first), opt[:time].change_my(:hour => opt[:max_hour], :min => 59, :sec => 59)]}
  end

  def ranges
    @@ranges_hourly
  end
end

