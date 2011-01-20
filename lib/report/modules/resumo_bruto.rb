
module ResumoBruto
  def resumo_bruto
    # Time.zone = "Brasilia"
    
    report = Hash.new
    date   = Time.now

    report[:month_and_year]  = "#{month[date.month]}/#{date.year}"
    report[:hour]            = "#{date.hour}:00"
    report[:day_and_month]   = "#{date.day}/#{date.month}"
    # report[:time_range]      = ["8h-#{date.hour}h", "0h-#{date.hour}h"]

    report[:date_start]   = (date-1.hour).strftime('%Y-%m-%d %H')+':00:00'
    report[:date_end]     = (date).strftime('%Y-%m-%d %H')+':00:00'

    report[:entries_received]     = Tweet.find(:all, :order => 'when_at desc', :conditions => ['from_user_id <> ? and when_at > ? and when_at < ?', '31217914',report[:date_start], report[:date_end] ])
    report[:entries_sent]     = Tweet.find(:all, :order => 'when_at desc', :conditions => ['from_user_id = ? and when_at > ? and when_at < ?', '31217914',report[:date_start], report[:date_end] ])

    # puts report[:entries].inspect
    # puts ':::::::::::::::: '
    # puts  report[:date_start]
    # puts report[:date_end]

    # entries_to_pizza = Entry.para_grafico_de_pizza.by_ebx_hourly(:max_hour => date.hour, :range => :canal)
    #  report[:chart_universe]  = MyGchart::HoraEmHora::Pizza::new.build_by(:width=>600, :height => 170, :entries => entries_to_pizza)
    # 
    #  entries_to_line  = Entry.para_grafico_de_linha_simples.by_ebx_hourly(:max_hour => date.hour, :range => :evolucao)
    #  report[:chart_evolution] = MyGchart::HoraEmHora::Line::new.build_by(:width=>600, :height => 170, :entries => entries_to_line)
    # 
    #  # Marqueti: Novo gráfico de distribuicao
    #  # Montando as datas
    #  data_inicio   = "#{date.year}-#{date.month}-#{date.day} #{(date-2.hour).hour}:00:00"
    #  data_final   = "#{date.year}-#{date.month}-#{date.day} #{date.hour}:00:00"
    #  
    #  report[:chart_distribuition]  = Gchart.pie(:title => '', :size => '750x350', :data => Product.get_products_totals(data_inicio, data_final), :labels => Product.get_products, :format => 'image_tag', :bar_colors => 'B00000,585858,FF9900,3399CC,000099,660033', :background => 'fff', :chart_background => 'f4f4f4')
 
    # ID 4 = Crítica
    # report[:critical_classifications] = Classification.find(:all, :conditions => ["created_at >= ? AND influence_id = 4", Time.new!], :order => "created_at desc", :limit=> 5)
    report
  end
end

