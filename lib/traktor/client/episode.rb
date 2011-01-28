module Traktor
  class Client
    class Episode
      attr_accessor :title, :url, :season, :number, :first_aired, :season

      def initialize(hash)
        @title, @url, @season, @number, @first_aired = hash['title'], hash['url'], hash['season'], hash['number'], Time.at(hash['first_aired'].to_i)
      end
    end
  end
end