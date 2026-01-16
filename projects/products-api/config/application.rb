# Rails.root: /home/embarca/products-api

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module ProductsApi
  class Application < Rails::Application
    config.load_defaults 7.0

    # API-only application
    config.api_only = true

    # Set default format to JSON
    config.default_response_format = :json

    # Autoload paths
    config.autoload_paths += %W[#{config.root}/app/services]

    # Timezone
    config.time_zone = "UTC"
  end
end
