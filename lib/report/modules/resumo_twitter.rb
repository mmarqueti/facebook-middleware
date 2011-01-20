
module ResumoTwitter
  def resumo_twitter
    report = Hash.new; date  = Time.now

    report[:month_and_year]  = "#{month[date.month]}/#{date.year}"
    report[:hour]            = "#{date.hour}:00"
    report[:day_and_month]   = "#{date.day}/#{date.month}"

    report[:date_start]      = "#{(date-2.hour).strftime('%Y-%m-%d %H')}:00:00"
    report[:date_end]        = "#{(date).strftime('%Y-%m-%d %H')}:00:00"

    contatos                     = Contact.contatos_por_mensagem(5).entre_datas(report[:date_start], report[:date_end])
    report[:contatos]            = new_array_from(contatos)      { |c| [c.username, c.total, c.klout] }

    contatos_resp                = Contact.contatos_respondidos(5).entre_datas(report[:date_start], report[:date_end])
    report[:contatosRespondidos] = new_array_from(contatos_resp) { |c| [c.to_user, c.total, Contact.find_by_username(c.to_user).klout] }

    contatos_qual                = Contact.contatos_qualidade(5).entre_datas(report[:date_start], report[:date_end])
    report[:contatosQualidade]   = new_array_from(contatos_qual) { |c| [c.username, c.total, c.klout] }

    return report
  end

  private
    def new_array_from(collection)
      collection.inject([]) do |array, c|
        array << yield(c)
      end
    end
end

