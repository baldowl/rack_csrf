require 'spec_helper'

describe Rack::Csrf do
  describe 'key' do
    it "should be 'csrf.token' by default" do
      Rack::Csrf.key.should == 'csrf.token'
    end

    it "should be the value of the :key option" do
      Rack::Csrf.new nil, :key => 'whatever'
      Rack::Csrf.key.should == 'whatever'
    end
  end

  describe 'csrf_key' do
    it 'should be the same as method key' do
      Rack::Csrf.method(:csrf_key).should == Rack::Csrf.method(:key)
    end
  end

  describe 'field' do
    it "should be '_csrf' by default" do
      Rack::Csrf.field.should == '_csrf'
    end

    it "should be the value of :field option" do
      Rack::Csrf.new nil, :field => 'whatever'
      Rack::Csrf.field.should == 'whatever'
    end
  end

  describe 'csrf_field' do
    it 'should be the same as method field' do
      Rack::Csrf.method(:csrf_field).should == Rack::Csrf.method(:field)
    end
  end

  describe 'token(env)' do
    let(:env) { {'rack.session' => {}} }

    specify {Rack::Csrf.token(env).should have_at_least(32).characters}

    context 'when accessing/manipulating the session' do
      before do
        Rack::Csrf.new nil, :key => 'whatever'
      end

      it 'should use the key provided by method key' do
        env['rack.session'].should be_empty
        Rack::Csrf.token env
        env['rack.session'][Rack::Csrf.key].should_not be_nil
      end
    end

    context 'when the session does not already contain the token' do
      it 'should store the token inside the session' do
        env['rack.session'].should be_empty
        token = Rack::Csrf.token(env)
        token.should == env['rack.session'][Rack::Csrf.key]
      end
    end

    context 'when the session already contains the token' do
      before do
        Rack::Csrf.token env
      end

      it 'should get the token from the session' do
        env['rack.session'][Rack::Csrf.key].should == Rack::Csrf.token(env)
      end
    end
  end

  describe 'csrf_token(env)' do
    it 'should be the same as method token(env)' do
      Rack::Csrf.method(:csrf_token).should == Rack::Csrf.method(:token)
    end
  end

  describe 'tag(env)' do
    let(:env) { {'rack.session' => {}} }

    let :tag do
      Rack::Csrf.new nil, :field => 'whatever'
      Rack::Csrf.tag env
    end

    it 'should be an input field' do
      tag.should =~ /^<input/
    end

    it 'should be an hidden input field' do
      tag.should =~ /type="hidden"/
    end

    it "should have the name provided by method field" do
      tag.should =~ /name="#{Rack::Csrf.field}"/
    end

    it "should have the value provided by method token(env)" do
      quoted_value = Regexp.quote %Q(value="#{Rack::Csrf.token(env)}")
      tag.should =~ /#{quoted_value}/
    end
  end

  describe 'csrf_tag(env)' do
    it 'should be the same as method tag(env)' do
      Rack::Csrf.method(:csrf_tag).should == Rack::Csrf.method(:tag)
    end
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
        csrf.send(:skip_checking, request).should be_false
      end
    end

    context 'when the request is included in the :skip list' do
      let(:csrf) { Rack::Csrf.new nil, :skip => ['POST:/hello'] }

      it 'should not run the check' do
        csrf.send(:skip_checking, request).should be_true
      end
    end

    context 'when the request is not included in the :skip list' do
      context 'but the request satisfies the custom check' do
        let(:csrf) { Rack::Csrf.new nil, :skip_if => lambda { |req| req.env.key?('HTTP_X_VERY_SPECIAL_HEADER') } }

        it 'should not run the check' do
          csrf.send(:skip_checking, request).should be_true
        end
      end

      context 'and the request does not satisfies the custom check' do
        context 'and the :check_only list is empty' do
          let(:csrf) { Rack::Csrf.new nil, :check_only => [] }

          it 'should run the check' do
            csrf.send(:skip_checking, request).should be_false
          end
        end

        context 'and the :check_only list is not empty' do
          context 'and the request is included in the :check_only list' do
            let(:csrf) { Rack::Csrf.new nil, :check_only => ['POST:/hello'] }

            it 'should run the check' do
              csrf.send(:skip_checking, request).should be_false
            end
          end

          context 'but the request is not included in the :check_only list' do
            let(:csrf) { Rack::Csrf.new nil, :check_only => ['POST:/ciao'] }

            it 'should not run the check' do
              csrf.send(:skip_checking, request).should be_true
            end
          end
        end
      end
    end
  end
end
