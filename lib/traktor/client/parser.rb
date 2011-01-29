module Traktor
  class Client
    # This will parse the result from the webservice to whatever it needs to be.
    class Parser
      def self.parse(response, options={})

        # Return nil if the result is false.
        return nil if response == 'false'

        # If the response is empty return an empty array.
        return [] if response.size == 0

        options[:to_return] ||= :undefined

        # Parse it from JSON first
        response = JSON.parse(response)

        case options[:to_return]
        when :watched_movies
          return response.map {|o| build_single_movie(o['movie'], o['watched'])}
        when :movies
          return response.map {|o| build_single_movie(o)}
        when :shows, :watched_episodes
          shows = {}
          response.each do |o|
            show = build_single_show(o)
            unless shows[show.url]
              shows[show.url] = show
            else
              shows[show.url].episodes << show.episodes.first
            end
          end
          return shows.values
        when :library_shows
          return response.map {|o| build_single_show(o, false)}
        when :watching
          case response['type'].downcase
          when 'movie'
            return build_single_movie(response['movie'])
          when 'episode'
            return build_single_show(response)
          end
        else
          raise "not implemented"
        end
      end



      def self.build_single_show(hash, include_episode=true)
        show_hash = include_episode ? hash['show'] : hash

        show = Show.new(show_hash['title'], show_hash['url'], show_hash['imdb_id'], show_hash['tvdb_id'], show_hash['year'])
        if include_episode
          show.episodes = [build_single_episode(hash['episode'])]
        end

        show
      end

      def self.build_single_episode(hash)
        Episode.new(hash['title'], hash['url'], hash['season'], hash['number'], parse_date(hash['first_aired']))
      end

      def self.build_single_movie(hash, watched_timestamp=nil)
        if watched_timestamp
          Movie.new(hash['title'], hash['year'], hash['url'], hash['imdb_id'], hash['tmdb_id'], true, parse_date(watched_timestamp))
        else
          Movie.new(hash['title'], hash['year'], hash['url'], hash['imdb_id'], hash['tmdb_id'], hash['watched'], nil)
        end
      end

      def self.parse_date(epoch_string)
        Time.at(epoch_string.to_i)
      end
    end
  end
end