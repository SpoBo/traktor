module Traktor
  class Client
    class Movie
      attr_accessor :title, :year, :url, :imdb_id, :tmdb_id, :watched_at

      def initialize(title, year, url, imdb_id, tmdb_id, watched, watched_at)
        @title, @year, @url, @imdb_id, @tmdb_id, @watched, @watched_at = title, year, url, imdb_id, tmdb_id, watched, watched_at
      end

      def == (other)
        @url == other.url
      end

      def watched?
        @watched
      end
    end
  end
end