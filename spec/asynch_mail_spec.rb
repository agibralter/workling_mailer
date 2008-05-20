require File.dirname(__FILE__) + '/spec_helper'

describe AsynchTestMailer, 'deliver_test_mail' do
  it "should create an email object" do
    MailerWorker.stub!(:asynch_deliver_mail)
    AsynchTestMailer.should_receive(:create_test_mail).with('noreply@autoki.de', 'joe@doe.com')
    AsynchTestMailer.deliver_test_mail 'noreply@autoki.de', 'joe@doe.com'
  end
  
  it "should send the mail to the worker" do
    AsynchTestMailer.stub!(:create_test_mail).and_return(:email)
    MailerWorker.should_receive(:asynch_deliver_mail).with(:class => 'AsynchTestMailer', :mail => :email)
    AsynchTestMailer.deliver_test_mail 'noreply@autoki.de', 'joe@doe.com'
  end
end

describe AsynchTestMailer, 'deliver_test_mail!' do
  it "should deliver the mail" do
    emails = ActionMailer::Base.deliveries
    emails.clear
    AsynchTestMailer.deliver_test_mail! 'noreply@autoki.de', 'joe@doe.com'
    emails.size.should == 1
  end
end

