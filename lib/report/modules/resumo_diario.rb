
module ResumoDiario
  def resumo_diario
    report = Hash.new
    date   = Time.now

    report[:month_and_year]  = "#{month[date.month]}/#{date.year}"
    report[:day_and_month]   = "#{date.strftime('%d/%m')}"
    report[:date_range]   = "#{(date - 1.day).strftime('%d/%m')} a #{date.strftime('%d/%m')}"
    report[:time_range]      = "10h-10h"
    # report[:total_entries]   = Entry.filtrado_entre_as_10_do_dia_anterior_ate_as_10_do_dia.count

    report[:date_start]   = date - 1.day
    report[:date_end]     = date

    contatos = Contact.contatos_por_mensagem(5).entre_datas(report[:date_start], report[:date_end])

    contatosCompletos = Array.new
    contatos.each do |c| 
     tmp = Array.new
     tmp << c.username
     tmp << c.total
     tmp << c.klout

     contatosCompletos << tmp
    end

    report[:contatos] = contatosCompletos
 

    contatosRespondidos = Contact.contatos_respondidos(5).entre_datas(report[:date_start], report[:date_end])
    contatosCompletosRes = Array.new
    contatosRespondidos.each do |c| 
      tmp = Array.new
      tmp << c.to_user
      tmp << c.total
      tmp << Contact.find_by_username(c.to_user).klout
      contatosCompletosRes << tmp
    end
    report[:contatosRespondidos] = contatosCompletosRes

    contatosQualidade = Contact.contatos_qualidade(5).entre_datas(report[:date_start], report[:date_end])
    contatosQualidadeRes = Array.new
    contatosQualidade.each do |c| 
      tmp = Array.new
      tmp << c.username
      tmp << c.total
      tmp << c.klout
      contatosQualidadeRes << tmp
    end
    report[:contatosQualidade] = contatosQualidadeRes


    # categorias = Category.total_por_categoria_graph
    categorias = Category.total_por_categoria_graph.entre_datas( report[:date_start], report[:date_end])
    categoriasFinal = Array.new
    categoriasLabel = Array.new
    labelsbar = Hash.new
    report[:categoriasTotal] = 0

    barra = ''
    categorias.each do |c| 
      categoriasFinal << c['total'].to_i#total.to_i
      report[:categoriasTotal] += c['total'].to_i
      categoriasLabel << c.name
      barra << ""+c.name+" ("+c['total'].to_s+")|"
      labelsbar.merge!(c.name => c['total'].to_i)
    end
    barra << "-"
    barra = barra.gsub('|-','')

    valoresEmPor = ""
    categorias.each do |c| 
        valoresEmPor << '%.2f' % (c['total'].to_i * 100.0 / report[:categoriasTotal]) + ","
    end
    valoresEmPor << "-"
    valoresEmPor = valoresEmPor.gsub(',-','')

    report[:categoriasFinal] = categoriasFinal
    report[:categoriasLabel] = categoriasLabel
    report[:labelsbar] = labelsbar

    report[:chart_distribuition] = "http://chart.apis.google.com/chart?chs=750x250&cht=p&chd=t:"+valoresEmPor+"&chp=0.1&chl="+barra

    # report[:chart_distribuition]  = Gchart.pie(
    # :custom => 'chdl='+barra,
    # # :title => 'Distribuição por categoria', 
    # :size => '750x300', 
    # :data => categoriasFinal, 
    # :labels => categoriasLabel, 
    # :format => 'image_tag'
    # :background => 'fff', 
    # :chart_background => 'f4f4f4')
    

    regua = Tweet.regua.entre_datas( report[:date_start], report[:date_end])
    reg = Array.new
    reg << regua[0]['positiva'].to_i
    reg << regua[0]['negativa'].to_i
    
    dadosRegua = Hash.new

    positivo = regua[0]['positiva'].to_i
    negativo = regua[0]['negativa'].to_i
    dadosRegua.merge!('Positiva' => positivo)
    dadosRegua.merge!('Negativa' => negativo)
    
    # calculando o indice do ponteiro
    if positivo > negativo
      total = positivo - negativo
    else
      total = negativo - positivo
    end
    porcento = negativo + positivo

    report[:exiteregua] = true

    if porcento > 0
      total = (positivo*100 / porcento)

      report[:regua] = dadosRegua
      report[:total] = porcento
      # report[:chart_regua]  = Gchart.meter(:title => 'Regua de favorabilidade', :size => '750x350', :data => [0]total, :labels => 'Indice', :format => 'image_tag', :bar_colors => 'B00000,585858,FF9900,3399CC,000099,660033', :background => 'fff', :chart_background => 'f4f4f4')

      report[:chart_regua] = 'http://chart.apis.google.com/chart?chs=750x200&cht=gom&chd=t:'+total.to_s+'&chl=Indice'

    else
      report[:exiteregua] = false
      report[:chart_regua] = 'http://chart.apis.google.com/chart?chs=750x200&cht=gom&chd=t:&chl=Indice'

    end

    
    report

  end
end

