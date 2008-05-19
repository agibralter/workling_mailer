# makes an actionmailer class queue its emails into a workling queue instead of sending them sycnhronously
module AsynchMail
  
  def self.included(base)
    create_worker_class base
    base.class_eval do
      class << self
        alias_method :orig_method_missing, :method_missing

        def method_missing(method_symbol, *parameters)#:nodoc:
          case method_symbol.id2name
            when /^deliver_([_a-z]\w*)\!/ then orig_method_missing(method_symbol, *parameters)
            when /^deliver_([_a-z]\w*)/ then queue_mail($1, *parameters)
            else orig_method_missing(method_symbol, *parameters)
          end
        end
        
        private

        def queue_mail(method, *parameters)
          mail = self.send "create_#{method}", *parameters
          worker_class.send "asynch_deliver_mail", mail
        end

        def worker_class
          ancestors.each do |ancestor|
            if Object.const_defined?(ancestor.to_s << 'Worker')
              return Object.const_get(ancestor.to_s << 'Worker')
            end
          end
        end
      end
    end
  end
  
  private
  
  def self.create_worker_class(base)
    worker_class = Class.new Workling::Base
    Object.const_set(base.to_s << 'Worker', worker_class)
    worker_class.send :include, WorkerMethods
  end
  
  module WorkerMethods
    def deliver_mail(mail)
      mailer_class.deliver mail
    end
    
    private
    def mailer_class
      Object.const_get self.class.name[0..-7]
    end
  end
end