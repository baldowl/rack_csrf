Cuba.define do
  on get do
    on '' do
      res.write render('views/form.erb')
    end

    on 'notworking' do
      res.write render('views/form_not_working.erb')
    end
  end

  on post do
    on 'response', param(:utterance), param(Rack::Csrf.field) do |utterance, csrf|
      res.write render('views/response.erb', :utterance => utterance, :csrf => csrf)
    end
  end
end
