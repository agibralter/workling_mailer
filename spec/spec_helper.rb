PLUGIN_ROOT = File.dirname(__FILE__) + '/..'

require 'rubygems'
gem 'actionmailer'
require 'actionmailer'

module Workling
  class Base
    def self.method_missing(method, *args, &block)
      if method.to_s =~ /^asynch_(.*)/
        self.new.send $1, *args
      else
        super
      end
    end
  end
end

ActionMailer::Base.delivery_method = :test

require PLUGIN_ROOT + '/lib/asynch_mail'
require PLUGIN_ROOT + '/lib/mailer_worker'

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
