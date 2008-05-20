# makes an actionmailer class queue its emails into a workling queue instead of sending them sycnhronously
module AsynchMail
  
  def self.included(base)
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
          MailerWorker.send "asynch_deliver_mail", :class => self.name, :mail => mail
        end
      end
    end
  end
  
end