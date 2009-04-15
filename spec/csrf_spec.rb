require File.dirname(__FILE__) + '/spec_helper.rb'

describe Rack::Csrf do
  describe '#csrf_field' do
    it "should be '_csrf'" do
      Rack::Csrf.csrf_field.should == '_csrf'
    end
  end

  describe '#csrf_token' do
    before do
      @env = {'rack.session' => {}}
    end

    it 'should be at least 32 characters long' do
      Rack::Csrf.csrf_token(@env).length.should >= 32
    end

    it 'should store the token inside the session if it is not already there' do
      @env['rack.session'].should be_empty
      Rack::Csrf.csrf_token(@env)
      @env['rack.session'].should_not be_empty
      @env['rack.session']['rack.csrf'].should_not be_empty
    end

    it 'should get the token from the session if it is already there' do
      @env['rack.session'].should be_empty
      csrf_token = Rack::Csrf.csrf_token(@env)
      csrf_token.should == @env['rack.session']['rack.csrf']
      csrf_token.should == Rack::Csrf.csrf_token(@env)
    end
  end

  describe '#csrf_tag' do
    before do
      @env = {'rack.session' => {}}
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
