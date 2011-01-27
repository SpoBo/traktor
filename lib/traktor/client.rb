require File.expand_path('../client/movie', __FILE__)
require File.expand_path('../client/exceptions', __FILE__)
require File.expand_path('../client/user_module', __FILE__)
require 'rest_client'

module Traktor
  class Client

    def initialize(options)
      @api_key = options[:api_key]
      @user = options[:user]
      @endpoint = 'http://api.trakt.tv'
    end

    include Traktor::Client::UserModule

    private

      # This is here for testing purposes. Shouldn't be used in general API usage.
      def user=(user)
        @user = user
      end
  end
end
