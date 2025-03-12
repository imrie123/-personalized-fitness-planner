# frozen_string_literal: true

class ApplicationController < ActionController::API
  config.before_configuration do
    Dotenv::Railtie.load
  end

  def verify_firebase_token(token)
    public_keys = FirebaseService.fetch_firebase_public_keys
    jwt_header = JWT.decode(token, nil, false)[1]
    kid = jwt_header['kid']
    public_key = OpenSSL::X509::Certificate.new(public_keys[kid]).public_key

    JWT.decode(token, public_key, true, { algorithm: 'RS256' })
  rescue StandardError => e
    Rails.logger.error "JWT Verification Error: #{e.message}"
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end
