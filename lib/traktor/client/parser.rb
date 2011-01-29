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
        when :shows
          return build_shows(response, false)
        when :watched_episodes
          return build_shows(response, true)
        when :library_shows
          return response.map {|o| build_single_show(o, false)}
        when :watching
          case response['type'].downcase
          when 'movie'
            return build_single_movie(response['movie'])
          when 'episode'
            return build_single_show(response)
          end
        when :watched # return a mixed array of movies & shows.
          watched = {}

          response.each do |o|
            case o['type'].downcase
            when 'movie'
              watched[o['url']] = build_single_movie(o['movie'], o['watched'])
            when 'episode'
              show = build_single_show(o)
              show.episodes[0].watched_at = parse_date(o['watched'])
              unless watched[show.url]
                watched[show.url] = show
              else
                watched[show.url].episodes << show.episodes.first
              end
            end
          end

          return watched.values
        else
          raise "not implemented"
        end
      end


      def self.build_shows(array, mark_all_as_watched)
        shows = {}
        array.each do |o|
          show = build_single_show(o, true, mark_all_as_watched)
          unless shows[show.url]
            shows[show.url] = show
          else
            shows[show.url].episodes << show.episodes.first
          end
        end
        shows.values
      end


      def self.build_single_show(hash, include_episode=true, watched=false)
        show_hash = include_episode ? hash['show'] : hash

        show = Show.new(show_hash['title'], show_hash['url'], show_hash['imdb_id'], show_hash['tvdb_id'], show_hash['year'])
        if include_episode
          episode = build_single_episode(hash['episode'])
          episode.watched = true if watched
          show.episodes = [episode]
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