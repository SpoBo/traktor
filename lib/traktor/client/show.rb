module Traktor
  class Client
    class Show
      attr_accessor :title, :url, :imdb_id, :tvdb_id, :episodes, :year

      def initialize(title, url, imdb_id, tvdb_id, year)
        @title, @url, @imdb_id, @tvdb_id, @year = title, url, imdb_id, tvdb_id, year
      end

      def == (other)
        @url == other.url
      end

    end
  end
end