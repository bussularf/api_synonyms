
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'api-synonyms-5ba648b892a3.herokuapp.com/'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
