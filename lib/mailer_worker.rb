class MailerWorker < Workling::Base
  def deliver_mail(options)
    Object.const_get(options[:class]).deliver options[:mail]
  end
end