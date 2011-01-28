module Traktor
  class Client
    # This will parse the result from the webservice to whatever it needs to be.
    class Parser
      def self.parse(response)

        # Return nil if the result is false.
        return nil if response == 'false'

        # If the response is empty return an empty array.
        return [] if response.size == 0

        # Parse it from JSON first
        response = JSON.parse(response)

        if response.is_a? Array
          # We should return either a collection of Movie or Show objects.
          if response[0]['show'] # So it's shows eeej?
            shows = {}
            response.each do |o|
              show = build_single_show(o)
              unless shows[show.imdb_id.to_sym]
                shows[show.imdb_id.to_sym] = show
              else
                shows[show.imdb_id.to_sym].episodes << show.episodes.first
              end
            end

            return shows.values # Neej it's movies!
          elsif response[0]['movie']
            response.map {|o| build_single_movie(o)}
          end
        elsif response['type'] # If we have a type we know it's either a movie or a show.
          case response['type'].downcase
          when 'movie'
            build_single_movie(response)
          when 'episode'
            build_single_show(response)
          end
        end
      end

      def self.build_single_show(hash)
        show = Show.new(hash['show']['title'], hash['show']['url'], hash['show']['imdb_id'], hash['show']['tvdb_id'])
        show.episodes = [build_single_episode(hash['episode'])]

        show
      end

      def self.build_single_episode(hash)
        Episode.new(hash['title'], hash['url'], hash['season'], hash['number'], Time.at(hash['first_aired'].to_i))
      end

      def self.build_single_movie(hash)
        Movie.new(hash['movie']['title'], hash['movie']['year'], hash['movie']['url'], hash['movie']['imdb_id'], hash['movie']['tmdb_id'])
      end

      def self.parse_date(json_date)
        seconds_since_epoch = json_date.scan(/[0-9]+/)[0].to_i
        return Time.at(seconds_since_epoch)
      end
    end
  end
end