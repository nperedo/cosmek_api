# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Specifies which domains are allowed to make requests to your API
    origins 'http://localhost:5173'

    # means these CORS rules apply to all routes/endpoints in your API
    # You could restrict this to specific paths like /api/* if needed
    resource '*',
    headers: :any,
    # Lists all HTTP methods that are allowed from the specified origin
    # This configuration allows all standard REST methods
    methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
