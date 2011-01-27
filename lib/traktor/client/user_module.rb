require 'json'

module Traktor
  class Client
    module UserModule

      def watched_movies(user=nil)
        ensure_user(user) do |user|
          JSON.parse(RestClient.get("#{@endpoint}/user/watched/movies.json/#{@api_key}/#{user}", :accept => :json)).
            map { |o| Movie.new(o['movie']) }
        end
      end

      protected

        def ensure_user(user)
          user ||= @user
          raise NoUserException.new() if user.nil?

          yield user # do the regular logic.
        end
    end
  end
end