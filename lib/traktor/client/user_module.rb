require 'json'

module Traktor
  class Client
    module UserModule

      def watched_movies(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watched/movies.json/#{@api_key}/#{user}", :accept => :json))
        end
      end


      def watched_episodes(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watched/episodes.json/#{@api_key}/#{user}", :accept => :json))
        end
      end

      def watching(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watching.json/#{@api_key}/#{user}", :accept => :json))
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