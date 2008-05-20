require File.dirname(__FILE__) + '/spec_helper'

describe 'integration of mailer and worker' do
  it "should send an email in the end" do
    AsynchTestMailer.deliver_test_mail 'me@source.org', 'you@dest.org'
    ActionMailer::Base.deliveries.size.should == 1
  end
end