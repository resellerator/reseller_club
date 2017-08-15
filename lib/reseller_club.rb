require 'httparty'
require 'uri'
require_relative 'reseller_club/version'
require_relative 'reseller_club/authentication'
require_relative 'reseller_club/customers'
require_relative 'reseller_club/contacts'
require_relative 'reseller_club/domains'

module ResellerClub
  class << self
    def base_uri=(base_uri)
      API.base_uri(base_uri)
    end

    def reseller_id=(reseller_id)
      API.default_params('auth-userid' => reseller_id)
    end

    def api_key=(api_key)
      API.default_params('api-key' => api_key)
    end

    def password=(password)
      API.default_params('auth-password' => password)
    end
  end

  class API
    include HTTParty
    debug_output $stdout

    base_uri 'https://httpapi.com/api'

    class Error < StandardError; end

    def self.get(*args)
      validate_settings!
      response = super
      if string = response.body[/\A"(.+)"\Z/, 1] # it's a string, not json
        json = string
      else
        json = JSON.parse(response.body)
        raise Error.new(json['message']) if json['status'] == 'ERROR'
      end
      json
    end

    def self.post(*args)
      validate_settings!
      response = super
      json = JSON.parse(response.body)
      raise Error.new(json['message']) if json['status'] == 'ERROR'
      json
    end

    def self.validate_settings!
      unless default_options[:default_params]['auth-userid'] and (default_options[:default_params]['api-key'] or default_options[:default_params]['auth-password'])
        raise Error.new('Missing API Configuration Settings')
      end
    end

  end
end
