class LittleApp
  @form = ERB.new <<-EOT
    <form action="/response" method="post">
      <h1>Spit your utterance!</h1>
      <input type="text" name="utterance">
      <%= Rack::Csrf.tag(env) %>
      <p><input type="submit" value="Send!"></p>
    </form>

    <p>Try also the <a href="/notworking">not working</a> form!</p>
  EOT

  @form_not_working = ERB.new <<-EOT
    <form action="/response" method="post">
      <h1>Spit your utterance!</h1>
      <input type="text" name="utterance">
      <p><input type="submit" value="Send!"></p>
    </form>

    <p>Try also the <a href="/">working</a> form!</p>
  EOT

  @response = ERB.new <<-EOT
    <p>It seems you've just said: <em><%= utterance %></em></p>

    <p>Here's the anti-CSRF token stuffed in the session: <strong><%= csrf %></strong></p>

    <p><a href='/'>Back</a></p>
  EOT

  def self.call env
    req = Rack::Request.new env
    res = Rack::Response.new

    if req.get?
      if req.path_info == '/notworking'
        res.write @form_not_working.result(binding)
      else
        res.write @form.result(binding)
      end
    elsif req.post?
      utterance = req['utterance']
      csrf = req[Rack::Csrf.field]
      res.write @response.result(binding)
    end

    res['Content-Type'] = 'text/html'
    res.finish
  end
end
