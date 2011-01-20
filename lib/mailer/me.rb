
class Mailer

  require 'pony'
  require 'erb'

  def self.get_mailing_list key, test

    emails = Array.new
    emails << "marcelo@bondix.com.br"
    emails << "marcelomarqueti@yahoo.com.br"
    emails << "gustavo@bondix.com.br"

    emails << "rafael@navigators.com.br"
    emails << "martha@navigators.com.br"
    emails << "luiz.otavio@navigators.com.br"
    emails << "celso@navigators.com.br"


    @@list ||= {
    :main => 'marcelo@navigators.com.br',
    :bcc  => emails,
    :test => ["rserradura@hotmail.com"]
    }

    if test.eql?('true')
      return @@list[:test] if key == :main
      return ""            if key == :bcc
    else
      return drop_emptys(@@list[key])
    end

  end


  def self.resumo_bruto test = nil

    template  = File.read 'views/email/resumo_bruto.erb'

    @report = Report.resumo_bruto

    Pony.mail(:to          => get_mailing_list(:main, test),
              :bcc         => get_mailing_list(:bcc, test),
              :from        => "nao_responda@navigators.com.br",
              :subject     => "EBX - Mensagens da última hora",
              :html_body   => ERB.new(template).result(binding),
              :via         => :smtp,
              :via_options => via_options)
  end


  def self.resumo_diario test = nil
    template  = File.read 'views/email/resumo_diario.erb'

    @report = Report.resumo_diario

    Pony.mail(:to          => get_mailing_list(:main, test),
              :bcc         => get_mailing_list(:bcc, test),
              :from        => "nao_responda@navigators.com.br",
              :subject     => "EBX - Status do twitter diário",
              :html_body   => ERB.new(template).result(binding),
              :via         => :smtp,
              :via_options => via_options)
  end


  def self.resumo_twitter test = nil

    template  = File.read 'views/email/resumo_twitter.erb'

    @report = Report.resumo_twitter

    Pony.mail(:to          => get_mailing_list(:main, test),
              :bcc         => get_mailing_list(:bcc, test),
              :from        => "nao_responda@navigators.com.br",
              :subject     => "EBX - Status do twitter 2 horas",
              :html_body   => ERB.new(template).result(binding),
              :via         => :smtp,
              :via_options => via_options)
  end


  private
    def self.via_options
      {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'alertas@bondix.com.br',
      :password             => 'bondix1313',
      :authentication       => :plain,
      :domain               => "bondix.com.br"
      }
    end


    def self.drop_emptys strings
      if strings.instance_of? Array
        return strings.delete_if {|email| (email.empty? || email.nil?)}
      else
        return strings
      end
    end

end

