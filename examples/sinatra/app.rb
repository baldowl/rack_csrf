get '/' do
  erb :form
end

get '/notworking' do
  erb :form_not_working
end

post '/response' do
  erb :response, :locals => {:utterance => params[:utterance],
    :csrf => params[Rack::Csrf.field]}
end
