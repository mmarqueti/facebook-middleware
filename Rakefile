
require File.join(File.dirname(__FILE__), "config", "environment")

#http://stackoverflow.com/questions/2940816/trying-to-use-activerecord-with-sinatra-migration-fails-question
#Necessário coloca-los fora para que o activerecord configurado nas tasks do delayed job funcione.
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Migration.verbose = true

namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end

desc "This task send a email with hourly result"
task :send_email_de_hora_em_hora do
  p Mailer.de_hora_em_hora
end


desc "This task send a email with the day result"
task :send_email_com_resumo_do_dia do
  p Mailer.resumo_diario
end


desc "This task send a email with the week result"
task :send_email_com_resumo_da_semana do
 p  Mailer.resumo_da_semana
end

