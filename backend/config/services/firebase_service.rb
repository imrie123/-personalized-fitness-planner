# frozen_string_literal: true

require 'net/http'
require 'json'

class FirebaseService
  def self.fetch_firebase_public_keys
    uri = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end
