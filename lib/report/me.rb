
Dir[File.join(File.dirname(__FILE__), 'modules', "*.rb")].each { |file| require file }

class Report

  extend ResumoDiario
  extend ResumoBruto
  extend ResumoTwitter

  def self.month
    @@month ||= {
      1 => "Janeiro",
      2 => "Fevereiro",
      3  => "Março",
      4  => "Abril",
      5  => "Maio",
      6  => "Junho",
      7  => "Julho",
      8  => "Agosto",
      9  => "Setembro",
      10 => "Outubro",
      11 => "Novembro",
      12 => "Dezembro"
     }

     @@month
  end


end

