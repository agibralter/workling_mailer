PLUGIN_ROOT = File.dirname(__FILE__) + '/..'
require PLUGIN_ROOT + '/lib/asynch_mail'

require 'rubygems'
gem 'actionmailer'
require 'actionmailer'

module Workling
  class Base
  end
end

ActionMailer::Base.delivery_method = :test