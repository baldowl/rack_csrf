require 'spec_helper'

describe Rack::Csrf do
  describe 'key' do
    it "should be 'csrf.token' by default" do
      expect(Rack::Csrf.key).to eq('csrf.token')
    end

    it 'should be the value of the :key option' do
      Rack::Csrf.new nil, :key => 'whatever'
      expect(Rack::Csrf.key).to eq('whatever')
    end
  end

  describe 'csrf_key' do
    it 'should be the same as method key' do
      expect(Rack::Csrf.method(:csrf_key)).to eq(Rack::Csrf.method(:key))
    end
  end

  describe 'field' do
    it "should be '_csrf' by default" do
      expect(Rack::Csrf.field).to eq('_csrf')
    end

    it 'should be the value of :field option' do
      Rack::Csrf.new nil, :field => 'whatever'
      expect(Rack::Csrf.field).to eq('whatever')
    end
  end

  describe 'csrf_field' do
    it 'should be the same as method field' do
      expect(Rack::Csrf.method(:csrf_field)).to eq(Rack::Csrf.method(:field))
    end
  end

  describe 'header' do
    subject { Rack::Csrf.header }
    it      { is_expected.to be == 'X_CSRF_TOKEN' }

    context 'when set to something' do
      before  { Rack::Csrf.new nil, :header => 'something' }
      subject { Rack::Csrf.header }
      it      { is_expected.to be == 'something' }
    end
  end

  describe 'csrf_header' do
    it 'should be the same as method header' do
      expect(Rack::Csrf.method(:csrf_header)).to eq(Rack::Csrf.method(:header))
    end
  end

  describe 'token(env)' do
    let(:env) { {'rack.session' => {}} }

    context 'should produce a token' do
      specify 'with at least 32 characters' do
        expect(Rack::Csrf.token(env).length).to be >= 32
      end

      specify 'without +, / or =' do
        expect(Rack::Csrf.token(env)).not_to match(/\+|\/|=/)
      end
    end

    context 'when accessing/manipulating the session' do
      before do
        Rack::Csrf.new nil, :key => 'whatever'
      end

      it 'should use the key provided by method key' do
        expect(env['rack.session']).to be_empty
        Rack::Csrf.token env
        expect(env['rack.session'][Rack::Csrf.key]).not_to be_nil
      end
    end

    context 'when the session does not already contain the token' do
      it 'should store the token inside the session' do
        expect(env['rack.session']).to be_empty
        token = Rack::Csrf.token(env)
        expect(token).to eq(env['rack.session'][Rack::Csrf.key])
      end
    end

    context 'when the session already contains the token' do
      before do
        Rack::Csrf.token env
      end

      it 'should get the token from the session' do
        expect(env['rack.session'][Rack::Csrf.key]).to eq(Rack::Csrf.token(env))
      end
    end
  end

  describe 'csrf_token(env)' do
    it 'should be the same as method token(env)' do
      expect(Rack::Csrf.method(:csrf_token)).to eq(Rack::Csrf.method(:token))
    end
  end

  describe 'tag(env)' do
    let(:env) { {'rack.session' => {}} }

    let :tag do
      Rack::Csrf.new nil, :field => 'whatever'
      Rack::Csrf.tag env
    end

    it 'should be an input field' do
      expect(tag).to match(/^<input/)
    end

    it 'should be an hidden input field' do
      expect(tag).to match(/type="hidden"/)
    end

    it 'should have the name provided by method field' do
      expect(tag).to match(/name="#{Rack::Csrf.field}"/)
    end

    it 'should have the value provided by method token(env)' do
      quoted_value = Regexp.quote %Q(value="#{Rack::Csrf.token(env)}")
      expect(tag).to match(/#{quoted_value}/)
    end
  end

  describe 'csrf_tag(env)' do
    it 'should be the same as method tag(env)' do
      expect(Rack::Csrf.method(:csrf_tag)).to eq(Rack::Csrf.method(:tag))
    end
  end

  describe 'metatag(env)' do
    let(:env) { {'rack.session' => {}} }

    context 'by default' do
      let :metatag do
        Rack::Csrf.new nil, :header => 'whatever'
        Rack::Csrf.metatag env
      end

      subject { metatag }
      it { is_expected.to match(/^<meta/) }
      it { is_expected.to match(/name="_csrf"/) }
      it 'should have the content provided by method token(env)' do
        quoted_value = Regexp.quote %Q(content="#{Rack::Csrf.token(env)}")
        expect(metatag).to match(/#{quoted_value}/)
      end
    end

    context 'with custom name' do
      let :metatag do
        Rack::Csrf.new nil, :header => 'whatever'
        Rack::Csrf.metatag env, :name => 'custom_name'
      end

      subject { metatag }
      it { is_expected.to match(/^<meta/) }
      it { is_expected.to match(/name="custom_name"/) }
      it 'should have the content provided by method token(env)' do
        quoted_value = Regexp.quote %Q(content="#{Rack::Csrf.token(env)}")
        expect(metatag).to match(/#{quoted_value}/)
      end
    end
  end

  describe 'csrf_metatag(env)' do
    it 'should be the same as method metatag(env)' do
      expect(Rack::Csrf.method(:csrf_metatag)).to eq(Rack::Csrf.method(:metatag))
    end
  end

  # Protected/private API

  describe 'rackified_header' do
    before  { Rack::Csrf.new nil, :header => 'my-header' }
    subject { Rack::Csrf.rackified_header }
    it      { is_expected.to be == 'HTTP_MY_HEADER'}
  end

  describe 'skip_checking' do
    let :request do
      double 'Request',
        :path_info => '/hello',
        :request_method => 'POST',
        :env => {'HTTP_X_VERY_SPECIAL_HEADER' => 'so true'}
    end

    context 'when the lists are empty and there is no custom check' do
      let(:csrf) { Rack::Csrf.new nil }

      it 'should run the check' do
        expect(csrf.send(:skip_checking, request)).to be false
      end
    end

    context 'when the request is included in the :skip list' do
      let(:csrf) { Rack::Csrf.new nil, :skip => ['POST:/hello'] }

      it 'should not run the check' do
        expect(csrf.send(:skip_checking, request)).to be true
      end
    end

    context 'when the request is not included in the :skip list' do
      context 'but the request satisfies the custom check' do
        let(:csrf) { Rack::Csrf.new nil, :skip_if => lambda { |req| req.env.key?('HTTP_X_VERY_SPECIAL_HEADER') } }

        it 'should not run the check' do
          expect(csrf.send(:skip_checking, request)).to be true
        end
      end

      context 'and the request does not satisfies the custom check' do
        context 'and the :check_only list is empty' do
          let(:csrf) { Rack::Csrf.new nil, :check_only => [] }

          it 'should run the check' do
            expect(csrf.send(:skip_checking, request)).to be false
          end
        end

        context 'and the :check_only list is not empty' do
          context 'and the request is included in the :check_only list' do
            let(:csrf) { Rack::Csrf.new nil, :check_only => ['POST:/hello'] }

            it 'should run the check' do
              expect(csrf.send(:skip_checking, request)).to be false
            end
          end

          context 'but the request is not included in the :check_only list' do
            let(:csrf) { Rack::Csrf.new nil, :check_only => ['POST:/ciao'] }

            it 'should not run the check' do
              expect(csrf.send(:skip_checking, request)).to be true
            end
          end
        end
      end
    end
  end

  describe 'found_a_valid_token?' do
    let(:env) { {'rack.session' => {}} }

    let(:csrf) { Rack::Csrf.new nil }

    let(:mock_request_env) do
      Rack::MockRequest.env_for '/hello',
        :method => 'POST',
        :input => 'foo=bar'
    end

    before do
      Rack::Csrf.token env
      mock_request_env['rack.session'] = env['rack.session']
    end

    context 'should be true' do
      specify "if a valid token can be found in the request's paramaters" do
        mock_request_env['rack.input'] = StringIO.new("#{Rack::Csrf.field}=#{Rack::Csrf.token(env)}")
        request = Rack::Request.new(mock_request_env)
        expect(csrf.send(:found_a_valid_token?, request)).to be true
      end

      specify "if a valid token can be found in the request's headers" do
        mock_request_env[Rack::Csrf.rackified_header] = Rack::Csrf.token(env)
        request = Rack::Request.new(mock_request_env)
        expect(csrf.send(:found_a_valid_token?, request)).to be true
      end
    end

    context 'should be false' do
      specify 'if no valid token can be found anywhere' do
        request = Rack::Request.new(mock_request_env)
        expect(csrf.send(:found_a_valid_token?, request)).to be false
      end
    end
  end
end
