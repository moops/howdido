require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Howdido
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # load env variables from config/application.yml
    config.before_configuration do
      env_file = Rails.root.join('config', 'application.yml')
      if File.exist?(env_file)
        YAML.safe_load(File.open(env_file)).each do |env, keys|
          next unless Rails.env == env
          keys.each do |key, value|
            # puts "#{Rails.env}: #{env}, #{key} = #{value}"
            ENV[key.to_s] = value
          end
        end
      end
    end

    # S3_CONFIG = YAML::load(File.open("#{Rails.root}/config/amazon_s3.yml"))
    config.time_zone = 'Pacific Time (US & Canada)'
    DATE_FORMAT = '%B %d %Y'.freeze
  end
end
