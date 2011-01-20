
require "rubygems" if RUBY_VERSION < "1.9"

# Gems necessárias
gem "rack"        , "1.1.0"
gem "sinatra"     , "1.0"
gem "activerecord", "2.3.8"
gem "actionmailer", "2.3.8"
gem "sinatra"     , "1.0"
gem "mysql"       , "2.8.1"
gem "pony"        , "1.0.1"

# Require All Models
 Dir[File.join(File.dirname(__FILE__), "..", "model", "*.rb")].each{ |file| require file }

# Require Libs
 require File.join(File.dirname(__FILE__), "..", "lib", "bondix", "me")
 require File.join(File.dirname(__FILE__), "..", "lib", "report", "me")
 require File.join(File.dirname(__FILE__), "..", "lib", "mailer", "me")

