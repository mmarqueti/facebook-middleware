
require File.join(File.dirname(__FILE__), "..", "db", "connection")

class Category < ActiveRecord::Base

  named_scope :total_por_categoria_graph, {
    :select => "c.name, count(t.id) total",
    :from   => "categories c",
    :joins  => "INNER JOIN categories_tweets ct ON ct.category_id = c.id INNER JOIN tweets t ON ct.tweet_id = t.id",
    :group => 'c.id'

  }
  
  named_scope :entre_datas, lambda {|inicio, fim| {:conditions => ["t.when_at > ? AND t.when_at < ?", inicio, fim] }}
  
end


