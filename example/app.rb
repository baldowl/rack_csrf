get '/' do
  erb :form
end

post '/response' do
  erb :response, :locals => {:utterance => params[:utterance],
    :csrf => params[Rack::Csrf.csrf_field]}
end
