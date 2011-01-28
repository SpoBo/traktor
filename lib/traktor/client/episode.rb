module Traktor
  class Client
    class Episode
      attr_accessor :title, :url, :season, :number, :first_aired

      def initialize(title, url, season, number, first_aired)
        @title, @url, @season, @number, @first_aired = title, url, season, number, first_aired
      end
    end
  end
end