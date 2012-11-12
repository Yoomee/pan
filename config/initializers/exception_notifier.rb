if Rails.env.production?
  Pan::Application.config.middleware.use ExceptionNotifier,
    :email_prefix => "[PAN] ",
    :sender_address => "notifier <notifier@pan.yoomee.com>",
    :exception_recipients => %w{developers@yoomee.com}
end