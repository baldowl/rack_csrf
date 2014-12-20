# Simulated session used just to be able to insert data into it without seeing
# them wiped out.
class FakeSession
  def initialize(app)
    @app = app
  end

  def call(env)
    env['rack.session'] ||= {}
    @app.call(env)
  end
end
