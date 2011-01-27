require 'json'

module Traktor
  class Client
    module UserModule

      def watched_movies(user=nil)
        user ||= @user

        raise NoUserException.new() if user.nil?

        JSON.parse(RestClient.get("#{@endpoint}/user/watched/movies.json/#{@api_key}/#{user}", :accept => :json)).
          map { |o| Movie.new(o['movie']) }
      end

    end
  end
end