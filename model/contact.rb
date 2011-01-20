
require File.join(File.dirname(__FILE__), "..", "db", "connection")

class Contact < ActiveRecord::Base

  validates_uniqueness_of :fb_id
  
  named_scope :entre_datas, lambda {|inicio, fim| {:conditions => ["t.when_at > ? AND t.when_at < ?", inicio, fim] }}

  named_scope :contatos_por_mensagem, lambda {|limite| {
  :select => 'c.id id, name, username, email, count(*) total, klout',
  :from   => "contacts c",    
  :joins => 'INNER JOIN tweets t ON t.contact_id=c.id ',
  :conditions => 'c.username <> "eikebatista" and c.username <> "" and c.username is not null', 
  :group => 'username, email',
  :order => 'total desc',
  :limit => limite}}
  
  named_scope :contatos_respondidos, lambda {|limite| {
  :select => 't.to_user, count(*) total, klout',
  :from   => "tweets t",    
  :joins => 'INNER JOIN contacts c ON t.contact_id=c.id ',
  :conditions => 't.from_user = "eikebatista" and t.to_user <> "" and c.username <> "" and c.username is not null', 
  :group => 't.to_user',
  :order => 'total desc',
  :limit => limite}}

  named_scope :contatos_qualidade, lambda {|limite| {
  :select => 'c.id id, name, username, email, count(*) total, klout',
  :from   => "contacts c",    
  :joins => 'INNER JOIN tweets t ON t.contact_id=c.id ',
  :conditions => 'c.username <> "eikebatista" and c.username <> "" and c.username is not null', 
  :group => 'username, email',
  :order => 'klout desc',
  :limit => limite }}


end

