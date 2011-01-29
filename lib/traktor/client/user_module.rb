require 'json'

module Traktor
  class Client
    module UserModule

      def watched_movies(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watched/movies.json/#{@api_key}/#{user}", :accept => :json), :to_return => :watched_movies)
        end
      end

      def watched_episodes(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watched/episodes.json/#{@api_key}/#{user}", :accept => :json), :to_return => :watched_episodes)
        end
      end

      def watching(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/watching.json/#{@api_key}/#{user}", :accept => :json), :to_return => :watching)
        end
      end

      def library_movies(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/library/movies.json/#{@api_key}/#{user}", :accept => :json), :to_return => :movies)
        end
      end

      def library_shows(user=nil)
        ensure_user(user) do |user|
          Parser.parse(RestClient.get("#{@endpoint}/user/library/shows.json/#{@api_key}/#{user}", :accept => :json), :to_return => :library_shows)
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