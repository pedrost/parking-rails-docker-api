require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    I18n.available_locales = ['pt-BR', :en]
    config.i18n.default_locale = :'pt-BR'
    config.api_only = true
  end
end
