
gem 'sidekiq'

after_bundle do
  # uncomment_lines 'config/puma.rb', /WEB_CONCURRENCY/
  # uncomment_lines 'config/puma.rb', /preload_app/

  inject_into_file '.gitignore' do
    <<~EOF
      /.env
      /.cache
      /.yarn
      /docker/postgres/backup.dump
    EOF
  end

  environment do <<~RUBY
    config.i18n.default_locale = :en
    config.time_zone = 'UTC'

    config.active_job.queue_adapter = :sidekiq

    config.generators do |g|
      g.assets false
      g.helper false
      g.jbuilder false
    end
  RUBY
  end

  file 'config/sidekiq.yml', <<~EOF
    ---
    :verbose: false
    :concurrency: 5
    :queues:
      - [critical, 2]
      - default
      - mailers
      - low

    production:
      :concurrency: 5

    staging:
      :concurrency: 5
  EOF

  file 'config/initializers/action_mailer.rb', <<~EOF
    ActionMailer::Base.default_url_options = {
      host: ENV['EMAIL_URL_HOST'],
      port: ENV['EMAIL_URL_PORT']
    }
    if Rails.env.development?
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = { address: 'mail', port: 1025 }

    elsif Rails.env.production?
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.smtp_settings = {
        :port           => ENV['SMTP_PORT'],
        :address        => ENV['SMTP_SERVER'],
        :user_name      => ENV['SMTP_USERNAME'],
        :password       => ENV['SMTP_PASSWORD'],
        :domain         => ENV['EMAIL_URL_HOST'],
        :authentication => :plain
      }
    end
  EOF
end

