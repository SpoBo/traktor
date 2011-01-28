module Traktor
  class Client
    class Show
      attr_accessor :title, :url, :imdb_id, :tvdb_id, :episodes

      def initialize(hash)
        @title, @url, @imdb_id, @tvdb_id = hash['title'], hash['url'], hash['imdb_id'], hash['tvdb_id']
        @episodes = []
      end

      # Build an array of Show objects.
      def self.build(hash)
        shows = {}

        # Loop every show/episode.
        hash.each { |o|
          # Add the show if it isn't added already.
          unless shows[o['show']['imdb_id'].to_sym]
            shows[o['show']['imdb_id'].to_sym] = Show.new(o['show'])
          end

          # Add the episode.
          shows[o['show']['imdb_id'].to_sym].episodes << Episode.new(o['episode'])
        }

        # Return only the Show objects.
        shows.values
      end
    end
  end
end