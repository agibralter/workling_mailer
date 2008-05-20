require File.dirname(__FILE__) + '/spec_helper'

describe MailerWorker, 'deliver_mail' do
  it "should send the mail back to the mailer" do
    AsynchTestMailer.should_receive(:deliver).with(:email)
    MailerWorker.new.deliver_mail :class => 'AsynchTestMailer', :mail => :email
  end
end
