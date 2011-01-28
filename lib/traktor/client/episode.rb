module Traktor
  class Client
    class Episode
      attr_accessor :title, :url, :season, :number, :first_aired, :season

      def initialize(hash)
        @title, @url, @season, @number, @first_aired = hash['title'], hash['url'], hash['season'], hash['number'], hash['first_aired']
      end
    end
  end
end