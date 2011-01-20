require "rubygems" if RUBY_VERSION < "1.9"
require "config/environment"
require "rack"
require "sinatra"
require 'oauth2'
require 'json'
require 'uri'
require 'net/http'

before do
  ActiveRecord::Base.connection.verify!
end

# PARA PENSAR
# mural pode ser o usuario + outros ou soh do usuario, setar uma flag e ver se o data.from.id é igual o da configuracao para aplicar um filtro
# alguns tem muito comentarios, qual o limite? senao temos que pegar no /post/comments
# tratar paginacao e ordenacao dos resultados dos comentarios e posts


set :access_token, nil
set :fwd_to, nil

# id profile bondix: 97070757020
# id profile mmarqueti: 732449366

get "/" do
  "<h2>Bondix :: CRM Facebook Midlleware v.: 1.0</h2>
  <br/>Para saber mais envie um <a href='mailto:contato@bondix.com.br'>email</a>
  <br/><br/><br/>Autorizar e logar via Facebook <a href='/auth/facebook'>aqui</a>
  <br/>Buscar posts e comentarios (bondix:97070757020) <a href='/auth/facebook/get_feed/97070757020'>aqui</a>
  "
end
# <!--<br/>Buscar posts e comentarios (140592842625856) <a href='/auth/facebook/get_feed/140592842625856'>aqui</a>-->
# <br/><br/><br/><br/>Ver minhas informacoes <a href='/auth/facebook/get_me'>aqui</a>
# <br/>Ver somente comentarios <a href='/auth/facebook/get_comments/140592842625856_170393019656469'>aqui</a>
# <br/>Ver somente comentarios (mais de 2K) <a href='/auth/facebook/get_comments/20531316728_144169955637289'>aqui</a>
# <br/>Postar mensagem no meu wall <a href='/auth/facebook/post_wall/732449366'>aqui</a>
# <br/>Postar comentario em um post especifico <a href='/auth/facebook/post_comment/97070757020_156989741014043/teste'>aqui</a>
# <br/>Processar e salvar no banco de dados <a href='/auth/facebook/processar/140592842625856'>aqui</a>
# <br/>Processar e salvar no banco de dados (teste carga alta)<a href='/auth/facebook/processar/20531316728'>aqui</a>



get "/ping" do
  "<h1>Bondix Midlleware Facebook v.: 1.0</h1>"
end

get "/test" do
  erb :test
end

def client
  #dev OAuth2::Client.new('108843935807196', '12b55eeb468b50426febbf96b7804b64', 
  #prod OAuth2::Client.new('179916468714775', '9a706a0a73cabf3dd31dcb35827a3ced', 
  
  OAuth2::Client.new('179916468714775', '9a706a0a73cabf3dd31dcb35827a3ced', 
    :site => 'https://graph.facebook.com'
  )
end

get '/auth/facebook' do
  redirect client.web_server.authorize_url(
    :redirect_uri => redirect_uri,
    :scope => 'email,offline_access'
  )
end

get '/auth/facebook/callback' do
  set :access_token, client.web_server.get_access_token(params[:code], :redirect_uri => redirect_uri)
  
  # if settings.fwd_to
  #   go_to = settings.fwd_to
  #   set :fwd_to, nil
  #   redirect go_to
  # else
    redirect '/'
  # end

end

get '/auth/facebook/get_feed/:id' do

  if not settings.access_token
    # set :fwd_to, request.path_info
    redirect '/auth/facebook'
  end
  
  id = params[:id]
  
  # Posts eh somente do usuario no wall da página
  # data = settings.access_token.get('/'+id+'/posts')
  
  # Feed são todos os posts no wall
  data = settings.access_token.get('/'+id+'/feed')
  feed = JSON.parse(data)  
  
  # tratar erro aqui
  # {
  #    "error": {
  #       "type": "OAuthException",
  #       "message": "Error validating access token."
  #    }
  # }
  

  # p feed.inspect
    
  html = '<a href="/">home</a>'  
  new_post_count = 0
  
  feed['data'].each do |d|
    # html << "<p>"+(d['message'] || d['name'])+"</p>"
    # html << "<p>"+d['id']+"</p>"
    # html << '<p>Qtd curtir? :'+d['likes'].to_s+'</p>' if d['likes']
    # html << '<p>Tipo :'+d['type']+'</p>'
    # html << '<p>Criado em : '+Time.parse(d['created_time']).strftime("%d/%m/%Y")+'</p>'
    # 
    # if d['comments']
    #   html << '<p><b>Commentarios</b></p>'
    #   d['comments']['data'].each do |c|
    #     html << '<p>'+c['from']['name']+' : id : '+c['from']['id']+'</p>'
    #     html << '<p>'+c['message']+'</p>'
    #     html << '<p>'+Time.parse(c['created_time']).strftime("%d/%m/%Y %H:M")+'</p>'
    #   end
    # end
    # 
    # html << '<hr/>'
    
    post = Post.new
    post.likes = d['likes']
    post.message = d['message']
    post.link = d['name']
    post.description = d['description']
    post.source = d['source']
    post.icon = d['icon']
    post.targeting = d['targeting']
    post.outid = d['id']
    post.parent_id = id
    post.posted_at = d['created_time'].to_time
    post.post_type = d['type']
    post.comments_count = d['comments']['count'] if d['comments'] and d['comments']['count']

    cto_fb = Contact.find(:first, :conditions => ['fb_id = ? ', d['from']['id']])
    if not cto_fb
      cto_fb = Contact.new(:fb_id => d['from']['id'], :outid => d['from']['id'], :name => d['from']['name'], :username => d['from']['name'], :user_id => d['from']['id'], :followers_count => '0', :followers_count => '0', :friends_count => '0', :statuses_count => '0', :listed_count => '0')
      cto_fb.save 
      cto_fb.reload
    end
    
    post.from_contact_id = cto_fb.id
    if post.save
      new_post_count += 1 
    else
      post = Post.find_by_outid(post.outid)
      post.update_attribute(:likes, d['likes']) if d['likes']
    end
    # se nao salvar, atualizar os likes ao menos
    
    # Verificar se o post foi enviado para ele, se sim criar um tweet com ele e associar a ele mesmo como post
    if d['from']['id'] != id
      Tweet.new(:outid => d['from']['id'], :from_user => d['from']['name'], :source => 'facebook', :iso_language_code => 'pt', :text => (d['message'] || '') +'; '+ (d['name'] || '') +'; '+ (d['link'] || ''), :language => 'pt', :to_user_id => d['to']['data'][0]['id'], :when_at => d['created_time'].to_time, :to_user => d['to']['data'][0]['name'], :from_user_id => d['from']['id'], :likes => d['likes'], :contact_id => cto_fb.id).save
    end
    
    
    post.get_comments(settings.access_token, post.outid, post.last_comment)

  end

  html << '<br/><br/>Novos posts : '+new_post_count.to_s
  
  html
end


get '/auth/facebook/post_comment/:post_id/:text' do

  if not settings.access_token
    # set :fwd_to, request.path_info
    redirect '/auth/facebook'
  end
  
  data = settings.access_token.post('/'+params[:post_id]+'/comments', :message => params[:text])
  data.inspect
  
  return '200'
   

end








# Sem utilizaçao agora
get '/auth/facebook/get_me' do
  
  if not settings.access_token
    set :fwd_to, request.path_info
    redirect '/auth/facebook'    
  end
  
  data = settings.access_token.get('/me')
  user = JSON.parse(data)  
  
  user.inspect
end


get '/auth/facebook/get_comments/:post_id' do

  if not settings.access_token
    set :fwd_to, request.path_info
    redirect '/auth/facebook'
  end
  
  data = settings.access_token.get('/'+params[:post_id]+'/comments?since=yesterday')
  feed = JSON.parse(data)  

  p feed.inspect
    
  html = '</br>'  
  feed['data'].each do |d|

    html << '<p><b>Commentarios</b></p>'
    html << '<p>'+d['from']['name']+' : id : '+d['from']['id']+'</p>'
    html << '<p>'+d['message']+'</p>'
    html << '<p>'+Time.parse(d['created_time']).strftime("%d/%m/%Y %H:M")+'</p>'
    
    html << '<hr/>'
  
  end
  
  html
end

get '/auth/facebook/processar/:page_id' do


  if not settings.access_token
    set :fwd_to, request.path_info
    redirect '/auth/facebook'
  end

  data = settings.access_token.get('/'+params[:page_id]+'/feed')
  feed = JSON.parse(data)  

  html = ''  
  feed['data'].each do |d|

    if d['comments']
      if d['comments']['data']
        # pegar aqui mesmo
        d['comments']['data'].each do |c|
          # Montar objeto e salvar
          p c['id'].to_s
        end
      else
        # pegar via novo request
          comments_json = settings.access_token.get('/'+d['id']+'/comments')
          comments = JSON.parse(comments_json)  
          comments['data'].each do |c|
            # Montar objeto e salvar
            p c['id'].to_s
          end
      end
      
    end
    
  end

  'Fim'

end

get '/auth/facebook/post_wall/:profile_id' do

  if not settings.access_token
    set :fwd_to, request.path_info
    redirect '/auth/facebook'
  end
  
  data = settings.access_token.post('/me/feed', :message => 'quase 6 da manha e eu testando api do facebook :)')
  data.inspect

end



def redirect_uri
  uri = URI.parse(request.url)
  uri.path = '/auth/facebook/callback'
  uri.query = nil
  uri.to_s
end



# Exemplos
# get "/relatorio/resumo_bruto" do
#   @report = Report.resumo_bruto
# 
#   erb(:'email/resumo_bruto')
# end

# get "/send/email/resumo_twitter" do
#   Mailer.resumo_twitter
# end

