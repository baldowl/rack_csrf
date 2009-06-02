require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe Rack::Csrf do
  describe '#csrf_field' do
    it "should be '_csrf' by default" do
      Rack::Csrf.csrf_field.should == '_csrf'
    end

    it "should be the value of :field option" do
      fakeapp = lambda {|env| [200, {}, []]}
      Rack::Csrf.new fakeapp, :field => 'whatever'
      Rack::Csrf.csrf_field.should == 'whatever'
    end
  end

  describe '#csrf_token' do
    before do
      @env = {'rack.session' => {}}
    end

    it 'should be at least 32 characters long' do
      Rack::Csrf.csrf_token(@env).length.should >= 32
    end

    context 'when the session does not already contain the token' do
      it 'should store the token inside the session' do
        @env['rack.session'].should be_empty
        csrf_token = Rack::Csrf.csrf_token(@env)
        @env['rack.session'].should_not be_empty
        @env['rack.session']['csrf.token'].should_not be_empty
        csrf_token.should == @env['rack.session']['csrf.token']
      end
    end

    context 'when the session already contains the token' do
      before do
        Rack::Csrf.csrf_token @env
      end
      it 'should get the token from the session' do
        @env['rack.session'].should_not be_empty
        @env['rack.session']['csrf.token'].should == Rack::Csrf.csrf_token(@env)
      end
    end
  end

  describe '#csrf_tag' do
    before do
      @env = {'rack.session' => {}}
      fakeapp = lambda {|env| [200, {}, []]}
      Rack::Csrf.new fakeapp, :field => 'whatever'
      @tag = Rack::Csrf.csrf_tag(@env)
    end

    it 'should be an input field' do
      @tag.should =~ /^<input/
    end

    it 'should be an hidden input field' do
      @tag.should =~ /type="hidden"/
    end

    it "should have the csrf_field's name" do
      @tag.should =~ /name="#{Rack::Csrf.csrf_field}"/
    end

    it "should have the csrf_token's output" do
      quoted_value = Regexp.quote %Q(value="#{Rack::Csrf.csrf_token(@env)}")
      @tag.should =~ /#{quoted_value}/
    end
  end
end
