
require "rubygems" if RUBY_VERSION < "1.9"
require 'active_record'

file = File.join(File.dirname(__FILE__), "..", "db", "database.yml")

db_config = YAML::load(File.open(file))
ActiveRecord::Base.establish_connection(db_config)

# Time.zone = "Brasilia"
# ActiveRecord::Base.time_zone_aware_attributes = true
# ActiveRecord::Base.default_timezone = "Brasilia"

# Time.zone = "UTC"
# ActiveRecord::Base.time_zone_aware_attributes = true
# ActiveRecord::Base.default_timezone = "UTC"
