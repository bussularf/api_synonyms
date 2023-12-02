
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '0.0.0.0:3000/'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
