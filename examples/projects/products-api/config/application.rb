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
    config.autoload_paths += %W[#{config.root}/app/serializers]

    # Timezone
    config.time_zone = "UTC"

    # CORS Configuration
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'localhost:3000', 'localhost:8080', '127.0.0.1'
        resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete]
      end
    end
  end
end
