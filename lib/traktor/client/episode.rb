module Traktor
  class Client
    class Episode
      attr_accessor :title, :url, :season, :number, :first_aired, :watched_at

      def initialize(title, url, season, number, first_aired)
        @title, @url, @season, @number, @first_aired = title, url, season, number, first_aired
        @watched = false
      end

      def watched?
        @watched
      end

      def watched=(value)
        @watched = value
      end

      def watched_at=(at)
        @watched = true
        @watched_at = at
      end
    end
  end
end