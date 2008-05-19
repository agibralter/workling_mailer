require File.dirname(__FILE__) + '/spec_helper'

class AsynchTestMailer < ActionMailer::Base
  include AsynchMail
  
  def test_mail(from, to)
    @subject    = 'subject'
    @body       = 'mail body'
    @recipients = to
    @from       = from
    @sent_on    = Time.now
    @headers    = {}
  end
end

class InheritedTestMailer < AsynchTestMailer; end

describe AsynchTestMailer do
  it "should create a worker for the mailer" do
    AsynchTestMailerWorker.superclass.should == Workling::Base
  end
end

describe AsynchTestMailerWorker, 'deliver_mail' do
  it "should send the mail back to the mailer" do
    AsynchTestMailer.should_receive(:deliver).with(:email)
    AsynchTestMailerWorker.new.deliver_mail :email
  end
end

describe AsynchTestMailer, 'deliver_test_mail' do
  it "should create an email object" do
    AsynchTestMailerWorker.stub!(:asynch_deliver_mail)
    AsynchTestMailer.should_receive(:create_test_mail).with('noreply@autoki.de', 'joe@doe.com')
    AsynchTestMailer.deliver_test_mail 'noreply@autoki.de', 'joe@doe.com'
  end
  
  it "should send the mail to the worker" do
    AsynchTestMailer.stub!(:create_test_mail).and_return(:email)
    AsynchTestMailerWorker.should_receive(:asynch_deliver_mail).with(:email)
    AsynchTestMailer.deliver_test_mail 'noreply@autoki.de', 'joe@doe.com'
  end
end

describe InheritedTestMailer, 'deliver_test_mail' do
  it "should send the mail to the worker of the superclass" do
    InheritedTestMailer.stub!(:create_test_mail).and_return(:email)
    AsynchTestMailerWorker.should_receive(:asynch_deliver_mail).with(:email)
    InheritedTestMailer.deliver_test_mail 'noreply@autoki.de', 'joe@doe.com'
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

