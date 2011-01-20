
Dir[File.join(File.dirname(__FILE__), "helpers", "*.rb")].each{ |file| require file }

module Conditions

  module To

    module EBX

      extend Hourly
      Hourly.create_range(:ebx_universo_canal, 8, 21, "Gráfico de pizza")
      Hourly.create_range(:ebx_evolucao, 6, 21, "Gráfico em linhas")
      Hourly.create_range(:ebx, 0, 23, "Filtrar tudo")

    end

  end

end

