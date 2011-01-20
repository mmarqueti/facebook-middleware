
require File.join(File.dirname(__FILE__), "..", "db", "connection")

class Post < ActiveRecord::Base

  has_many :tweets
  validates_uniqueness_of :outid
  

  named_scope :total_por_categoria_graph, {
    :select => "c.name, count(t.id) total",
    :from   => "categories c",
    :joins  => "INNER JOIN categories_tweets ct ON ct.category_id = c.id INNER JOIN tweets t ON ct.tweet_id = t.id",
    :group => 'c.id'

  }
  
  named_scope :entre_datas, lambda {|inicio, fim| {:conditions => ["t.when_at > ? AND t.when_at < ?", inicio, fim] }}
  
  
  def get_comments(token, outid, last_comment)
    require 'uri'

    if last_comment
      data = token.get('/'+outid+'/comments?since='+URI.encode(last_comment.strftime('%Y-%m-%d %H:%M:%S')))
    else
      data = token.get('/'+outid+'/comments')
    end

    feed = JSON.parse(data)  
    # p feed.inspect

    tweet = Tweet.new        
    feed['data'].each do |d|
       
      cto_fb = Contact.find(:first, :conditions => ['fb_id = ? ', d['from']['id']])
      if not cto_fb
        cto_fb = Contact.new(:fb_id => d['from']['id'], :outid => d['from']['id'], :name => d['from']['name'], :username => d['from']['name'], :user_id => d['from']['id'], :followers_count => '0', :followers_count => '0', :friends_count => '0', :statuses_count => '0', :listed_count => '0')
        cto_fb.save 
        cto_fb.reload
      end

      tu = Tweet.new(:outid => d['id'], :from_user => d['from']['name'], :source => 'facebook', :iso_language_code => 'pt', :text => d['message'], :language => 'pt', :when_at => d['created_time'].to_time, :from_user_id => d['from']['id'], :likes => d['likes'], :contact_id => cto_fb.id)
      tu.save

      post = Post.find_by_outid(outid)
      post.last_comment = d['created_time'].to_time
      post.save
      # se nao salvar, atualizar os likes ao menos
    end
    
   end
  
end


