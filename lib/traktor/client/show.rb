module Traktor
  class Client
    class Show
      attr_accessor :title, :url, :imdb_id, :tvdb_id, :episodes

      def initialize(title, url, imdb_id, tvdb_id)
        @title, @url, @imdb_id, @tvdb_id = title, url, imdb_id, tvdb_id
      end

      def == (other)
        @url == other.url
      end

    end
  end
end