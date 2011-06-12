require 'camping'
require 'camping/session'

$: << File.join(File.dirname(__FILE__), '../../lib')
require 'rack/csrf'

Camping.goes :LittleApp

module LittleApp
  use Rack::Csrf # This has to come BEFORE 'include Camping::Session',
                 # otherwise you get the 'Rack::Csrf depends on session 
                 # middleware' exception. Weird...
  include Camping::Session

  module Controllers
    class Working < R '/'
      def get
        render :working
      end
    end

    class NotWorking < R '/notworking'
      def get
        render :notworking
      end
    end

    class Response < R '/response'
      def post
        render :response
      end
    end
  end

  module Views
    def working
      form :action => URL(Response), :method => :post do
        h1 'Spit your utterance!'
        input :name => :utterance, :type => :text
        text Rack::Csrf.tag(@env)
        p {
          input :type => :submit, :value => :Send!
        }
      end
      p {
        text 'Try also the '
        a 'not working', :href => URL(NotWorking)
        text ' form!'
      }
    end

    def notworking
      form :action => URL(Response), :method => :post do
        h1 'Spit your utterance!'
        input :name => :utterance, :type => :text
        p {
          input :type => :submit, :value => :Send!
        }
      end
      p {
        text 'Try also the '
        a 'working', :href => URL(Working)
        text ' form!'
      }
    end

    def response
      p {
        text "It seems you've just said: "
        em @input.utterance
      }
      p {
        text "Here's the anti-CSRF token stuffed in the session: "
        strong @input._csrf
      }
      p {
        a 'Back', :href => URL(Working)
      }
    end
  end
end
