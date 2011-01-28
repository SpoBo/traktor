module Traktor
  class Client
    class Movie
      attr_accessor :title, :year, :url, :imdb_id, :tmdb_id

      def initialize(title, year, url, imdb_id, tmdb_id)
        @title, @year, @url, @imdb_id, @tmdb_id = title, year, url, imdb_id, tmdb_id
      end
    end
  end
end