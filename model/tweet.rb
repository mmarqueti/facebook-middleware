require File.join(File.dirname(__FILE__), "..", "db", "connection")

class Tweet < ActiveRecord::Base
 
  belongs_to :post
  validates_uniqueness_of :outid

  named_scope :entre_datas, lambda {|inicio, fim| {:conditions => ["t.when_at > ? AND t.when_at < ?", inicio, fim] }}

  named_scope :regua, {
  :select => 'sum(IF(influence_id = "2", klout,0)) AS "negativa", sum(IF(influence_id = "1", klout,0)) AS "positiva"',
  :from   => "tweets t",    
  :joins => 'inner join contacts c on t.contact_id = c.id'
  }




  # SELECT sum(IF(influence_id = '2', klout,0)) AS 'indice negativa', sum(IF(influence_id = '1', klout,0)) AS 'indice positiva'
  # FROM tweets t
  # inner join contacts c on t.contact_id = c.id
# Mensagens classificadas (negativas e positivas) X Klout Score

# SELECT SUBSTRING_INDEX(author, ' ', 1) as login, count(*) as total, (sum(target)/count(*)) as impactos, sum(IF(classifications.influence_id = '3', 1,0)) AS 'positiva', sum(IF(classifications.influence_id = '2', 1,0)) AS 'negativa', sum(IF(classifications.influence_id = '1', 1,0)) AS 'neutra' , sum(IF(classifications.influence_id = '4', 1,0)) AS 'critica', (sum(entries.klout)/count(entries.klout)) AS 'klout' 
# FROM entries
# INNER JOIN classifications ON classifications.entry_id = entries.id 
# INNER JOIN entries_labels ON entries.id = entries_labels.entry_id 
# INNER JOIN labels ON labels.id = entries_labels.label_id 
# INNER JOIN products ON products.id = labels.product_id 
# WHERE entries.origem = 'twitter' and products.id = '"+@pr.id.to_s+"'
# AND entries.pubdate > '"+ @inicio +" 00:00:00' 
# AND entries.pubdate < '"+ @fim +" 23:59:59' 
#   AND entries.is_active = 1
# GROUP BY SUBSTRING_INDEX(author, ' ', 1) 
# ORDER BY total DESC

end

