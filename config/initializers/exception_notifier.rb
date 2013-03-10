if Rails.env.production?
  Pan::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[TOURBOOK] ",
    :sender_address => "notifier <notifier@tourbook.org.uk>",
    :exception_recipients => %w{developers@yoomee.com}
end