class LittleApp
  @form = ERB.new <<-EOT
    <form action="/some_action" method="post">
      <input type="text" name="some_field">
      <%= Rack::Csrf.tag(env) %>
      <p><input type="submit" value="Send!"></p>
    </form>
  EOT

  def self.call env
    req = Rack::Request.new env
    if req.path_info == '/form'
      Rack::Response.new(@form.result(binding)).finish
    else
      Rack::Response.new('Hello world!').finish
    end
  end
end
