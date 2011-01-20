
class Object
  def to_ss
    if self.nil?
      return ""
    else
      return self
    end
  end
end

class MyGchart

  class HoraEmHora

    class Pizza
      def size width, height
        width  = 300 if width.nil?
        height = 150 if height.nil?
        @size  = "chs=#{width}x#{height}"
      end

      def data args
        @data = "chd=t:#{args.join(',')}"
      end

      def label label
        @label = "chdl=#{label}"
      end

      def data_label label
        @data_label = "chl=#{label}"
      end

      def build
        "http://chart.apis.google.com/chart?" + @size + "&cht=p&" + @data + "&" + @label + "&chp=0.1&" + @data_label
      end

      def build_by options
        report       = {:label => "", :data => [], :data_label => "" }
        total_qtd    = options[:entries].inject(0.0) { |sum, entry| sum + entry.qtd.to_i  }
        entries_size = options[:entries].size

        i = 1
        for entry in options[:entries]
          last = (i+1 <= entries_size)
          report[:label] << "#{entry.label} (#{entry.qtd})#{ last ? '|' : ''}"
          report[:data]  << ((entry.qtd.to_i / total_qtd.to_f) * 100)
          report[:data_label] << "#{'%.0f' % ((entry.qtd.to_i / total_qtd.to_f) * 100)}%#{ last ? '|' : ''}"
          i+=1
        end

        size options[:width], options[:height]
        data(report[:data])
        label(report[:label])
        data_label(report[:data_label])

        build
      end
    end

    class Line

      require "rubygems"
      require "googlecharts"

      def size width, height
        width  = 300 if width.nil?
        height = 150 if height.nil?
        @size  = "chs=#{width}x#{height}"
      end

      # label = 6h|8h|10h|12h|14h|16h|18h|20h
      def label label
        @label = "chxl=0:|#{label}"
      end

      def max_value value
        @max_value = "chxr=1,0,#{value}"
      end

      def data args
        @data = "chd=s:AA,#{Gchart.line(:data => args)[/s\:[^&]*/][2..-1]}"
      end

      def build
        "http://chart.apis.google.com/chart?" + @size + "&cht=lc&" + @label + "&" + @data + "&" + @max_value + "&chg=25,50&chls=0.75,-1,-1|2,4,1&chm=o,FF9900,1,-1,8|b,3399CC44,0,1,0&chxt=x,y"
      end

      def build_by options

        report       = {:label => "", :data => [] }
        max_qtd      = options[:entries].max {|a,b| a.qtd.to_i <=> b.qtd.to_i}.qtd.to_f
        entries_size = options[:entries].size

        i = 1
        for entry in options[:entries]
          last = (i+1 <= entries_size)
          report[:label] << "#{entry.label}h#{ last ? '|' : ''}"
          # report[:data]  << "#{'%.2f' % ((entry.qtd / max_value) * 100)}".to_f
          report[:data]  << ((entry.qtd.to_i / max_qtd) * 100)
          i+=1
        end

        size(options[:width], options[:height])
        label(report[:label])
        max_value(max_qtd)
        data(report[:data])

        build
      end
    end

  end

  class DiarioESemanal

    class Pizza
      def size width, height
        width  = 300 if width.nil?
        height = 150 if height.nil?
        @size  = "chs=#{width}x#{height}"
      end

      def data args
        @data = "chd=t:#{args.join(',')}"
      end

      def label label
        @label = "chdl=#{label}"
      end

      def build
        "http://chart.apis.google.com/chart?" + @size + "&cht=p&" + @data + "&" + @label + "&chp=0.1&"
      end

      def build_by options
        report       = {:label => "", :data => [], :data_label => "" }
        total_qtd    = options[:entries].inject(0.0) { |sum, entry| sum + entry.qtd.to_i  }
        entries_size = options[:entries].size

        i = 1
        for entry in options[:entries]
          last = (i+1 <= entries_size)

          data_label = "#{'%.0f' % ((entry.qtd.to_i / total_qtd.to_f) * 100)}%"
          report[:label] << "#{entry.label} (#{entry.qtd}-#{data_label})#{ last ? '|' : ''}"

          report[:data]  << ((entry.qtd.to_i / total_qtd.to_f) * 100)
          i+=1
        end

        size options[:width], options[:height]
        data(report[:data])
        label(report[:label])

        build
      end
    end

    class Barra

      def size width, height
        width  = 300 if width.nil?
        height = 150 if height.nil?
        @size  = "chs=#{width}x#{height}"
      end

      # ["1,2","3,4"]
      def data args
        @data = "&chd=t:#{args.join('|')}"
      end

      def label label
        label = "Total|Positivo|Negativo" if label.nil?
        @label = "chdl=#{label}"
      end

      #chxl=0:|Twitter|Google
      def axe_y_values values
        @axe_y_values = "chxl=0:#{values}"
      end

      def color color

        unless color.nil?
          total    = "3366CC" if color[:total].nil?
          positivo = "008000" if color[:positivo].nil?
          negativo = "FF0000" if color[:negativo].nil?
        else
          total    = "3366CC"; positivo = "008000"; negativo = "FF0000"
        end

        @color   = "chco=#{total},#{positivo},#{negativo}"
      end

      def bar_labels labels
        @bar_labels = "chm=tAzul1,000000,0,0,13|tAzul2,000000,0,1,13,-1|tVerde1,000000,1,0,13|tVerde2,000000,1,1,13|tVermelho1,000000,2,0,13|tVermelho2,000000,2,1,13"
        @bar_labels = "chm=#{labels}"
      end

      def build
        "http://chart.apis.google.com/chart?" + @size + "&cht=bhg" + @data + "&" + @label + "&" + @axe_y_values + "&" + @color + "&" + @bar_labels + "&chxt=y&chbh=a,0,15&chds=0,110,0,110,0,110"
      end

      def build_by options
        report       = {
                        :data => {:total => [], :positivo => [], :negativo => []},
                        :axe_y_values => [],
                        :bar_labels   => ""
                        }
        entries_size = options[:entries].size

        i = 1
        for entry in options[:entries]
          last = (i+1 <= entries_size)

          report[:data][:total]    << entry.total
          report[:data][:positivo] << entry.positivo
          report[:data][:negativo] << entry.negativo

          report[:axe_y_values] << entry.label

          i+=1
        end

=begin
        data_sum = {:total => nil, :positivo => nil, :negativo => nil}
        data_sum[:total]    = report[:data][:total].inject(0.0) { |sum, n| sum + n}
        data_sum[:positivo] = report[:data][:positivo].inject(0.0) { |sum, n| sum + n}
        data_sum[:negativo] = report[:data][:negativo].inject(0.0) { |sum, n| sum + n}


        data_values = []
        for key, total in data_sum
          data_s = ""
          i = 1
          report[:data][key].each { |value|
            last = (i+1 <= report[:data][key].size)
            data_s << "#{'%.2f' % ((value/total)*100)}#{ last ? ',' : ''}"
          }

          data_values << data_s.chop
        end
=end

        total  = report[:data][:total].inject(0.0) { |sum, n| sum + n.to_i}

        data_values = []
        totals_to_calc = []
        data_s = ""

        i = 1
        for value in report[:data][:total]
          last = (i+1 <= report[:data][:total].size)
          totals_to_calc << value.to_i/total
          data_s << "#{'%.2f' % ((value.to_i/total)*100)}#{ last ? ',' : ''}"
        end
        data_values << data_s.chop


        data_label = {:total => "", :positivo => "", :negativo => ""}

        positivo = ""
        negativo = ""
        for i in 0..(totals_to_calc.size-1)

          positivo << "#{'%.2f' % (totals_to_calc[i] * ((report[:data][:positivo][i].to_i / report[:data][:total][i].to_f) * 100))},"
          negativo << "#{'%.2f' % (totals_to_calc[i] * ((report[:data][:negativo][i].to_i / report[:data][:total][i].to_f) * 100))},"

         data_label[:total] << "t#{report[:data][:total][i]},000000,0,#{i},13|"
         data_label[:positivo] << "t#{report[:data][:positivo][i]},000000,1,#{i},13|"
         data_label[:negativo] << "t#{report[:data][:negativo][i]},000000,2,#{i},13|"

        end
        data_values << positivo.chop
        data_values << negativo.chop

        size         options[:width], options[:height]
        data         data_values
        label        options[:label]
        axe_y_values "|#{report[:axe_y_values].reverse.join('|')}"
        color        options[:color]
        bar_labels   [data_label[:total].chop, data_label[:positivo].chop, data_label[:negativo].chop].join("|")

        build
      end
    end

    class Line

      require "rubygems"
      require "googlecharts"

      def size width, height
        width  = 300 if width.nil?
        height = 150 if height.nil?
        @size  = "chs=#{width}x#{height}"
      end

      # label = 01/08|02/08|03/08|04/08|05/08|06/08|07/08
      # chxl=0:|01/08|02/08|03/08|04/08|05/08|06/08|07/08
      def label label
        @label = "chxl=0:|#{label}"
      end

      def max_value value
        @max_value = "chxr=1,0,#{value}"
      end

      # chd=s:rhafpk3,TcTTVTZ,gNEIKUX
      def data args
        data = Gchart.line(:data => [args[:total],args[:positivo],args[:negativo]])[/chd\=s\:[^\&]*/][6..-1].split(",")
        @data = "chd=s:#{data.join(',')}"
      end

      # chco=3366CC,008000,FF0000
      def color color

        unless color.nil?
          total    = "3366CC" if color[:total].nil?
          positivo = "008000" if color[:positivo].nil?
          negativo = "FF0000" if color[:negativo].nil?
        else
          total    = "3366CC"; positivo = "008000"; negativo = "FF0000"
        end

        @color   = "chco=#{total},#{positivo},#{negativo}"
      end

      def legend label
        legend = "Total|Positivo|Negativo" if label.nil?
        @legend = "chdl=#{legend}"
      end

      def build
        "http://chart.apis.google.com/chart?" + @size.to_ss + "&cht=lc&" + @label.to_ss + "&" + @data.to_ss + "&" + @max_value.to_ss + "&" + @color.to_ss + "&" + @legend.to_ss + "&chxt=x,y&chg=25,25&chls=0.75,-1,-1|0.75,5,0|3,4,1&chm=b,EFEFEF66,0,1,0"
      end

      def build_by options

        report       = {:label => "", :data => {:total => [], :positivo => [], :negativo => []} }
        unless options[:entries].empty?
          max_qtd      = options[:entries].max {|a,b| a.total.to_i <=> b.total.to_i}.total.to_f
          entries_size = options[:entries].size

          i = 1
          for entry in options[:entries]
            last = (i+1 <= entries_size)
            report[:label] << "#{entry.label}#{ last ? '|' : ''}"
            # report[:data]  << "#{'%.2f' % ((entry.qtd / max_value) * 100)}".to_f
            report[:data][:total]    << ((entry.total.to_i / max_qtd) * 100)
            report[:data][:positivo] << ((entry.positivo.to_i / max_qtd) * 100)
            report[:data][:negativo] << ((entry.negativo.to_i / max_qtd) * 100)
            i+=1
          end

          label(report[:label])
          data(report[:data])
          max_value(max_qtd)
        end

        size(options[:width], options[:height])
        color(options[:color])
        legend(options[:legend])

        build
      end
    end

  end
end

