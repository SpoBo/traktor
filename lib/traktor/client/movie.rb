module Traktor
  class Client
    class Movie
      attr_accessor :title, :year, :url, :imdb_id, :tmdb_id

      def initialize(hash)
        @title, @year, @url, @imdb_id, @tmdb_id = hash['title'], hash['year'], hash['url'], hash['imdb_id'], hash['tmdb_id']
      end
    end
  end
end