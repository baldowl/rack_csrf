require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe Rack::Csrf do
  describe 'csrf_key' do
    it "should be 'csrf.token' by default" do
      Rack::Csrf.csrf_key.should == 'csrf.token'
    end

    it "should be the value of the :key option" do
      fakeapp = lambda {|env| [200, {}, []]}
      Rack::Csrf.new fakeapp, :key => 'whatever'
      Rack::Csrf.csrf_key.should == 'whatever'
    end
  end

  describe 'key' do
    it 'should be the same as csrf_key' do
      Rack::Csrf.method(:key).should == Rack::Csrf.method(:csrf_key)
    end
  end

  describe 'csrf_field' do
    it "should be '_csrf' by default" do
      Rack::Csrf.csrf_field.should == '_csrf'
    end

    it "should be the value of :field option" do
      fakeapp = lambda {|env| [200, {}, []]}
      Rack::Csrf.new fakeapp, :field => 'whatever'
      Rack::Csrf.csrf_field.should == 'whatever'
    end
  end

  describe 'field' do
    it 'should be the same as csrf_field' do
      Rack::Csrf.method(:field).should == Rack::Csrf.method(:csrf_field)
    end
  end

  describe 'csrf_token(env)' do
    let(:env) { {'rack.session' => {}} }

    specify {Rack::Csrf.csrf_token(env).should have_at_least(32).characters}

    context 'when accessing/manipulating the session' do
      before do
        fakeapp = lambda {|env| [200, {}, []]}
        Rack::Csrf.new fakeapp, :key => 'whatever'
      end

      it 'should use the key provided by csrf_key' do
        env['rack.session'].should be_empty
        Rack::Csrf.csrf_token env
        env['rack.session'][Rack::Csrf.csrf_key].should_not be_nil
      end
    end

    context 'when the session does not already contain the token' do
      it 'should store the token inside the session' do
        env['rack.session'].should be_empty
        csrf_token = Rack::Csrf.csrf_token(env)
        csrf_token.should == env['rack.session'][Rack::Csrf.csrf_key]
      end
    end

    context 'when the session already contains the token' do
      before do
        Rack::Csrf.csrf_token env
      end

      it 'should get the token from the session' do
        env['rack.session'][Rack::Csrf.csrf_key].should == Rack::Csrf.csrf_token(env)
      end
    end
  end

  describe 'token(env)' do
    it 'should be the same as csrf_token(env)' do
      Rack::Csrf.method(:token).should == Rack::Csrf.method(:csrf_token)
    end
  end

  describe 'csrf_tag(env)' do
    let(:env) { {'rack.session' => {}} }

    let :tag do
      fakeapp = lambda {|env| [200, {}, []]}
      Rack::Csrf.new fakeapp, :field => 'whatever'
      Rack::Csrf.csrf_tag env
    end

    it 'should be an input field' do
      tag.should =~ /^<input/
    end

    it 'should be an hidden input field' do
      tag.should =~ /type="hidden"/
    end

    it "should have the csrf_field's name" do
      tag.should =~ /name="#{Rack::Csrf.csrf_field}"/
    end

    it "should have the csrf_token's output" do
      quoted_value = Regexp.quote %Q(value="#{Rack::Csrf.csrf_token(env)}")
      tag.should =~ /#{quoted_value}/
    end
  end

  describe 'tag(env)' do
    it 'should be the same as csrf_tag(env)' do
      Rack::Csrf.method(:tag).should == Rack::Csrf.method(:csrf_tag)
    end
  end
end
