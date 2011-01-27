require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe Traktor::Client::UserModule do

  before do
    @traktor = Traktor.client(:api_key => "valid")
  end

  describe ".watched_movies" do

    before do
      stub_request(:get, "http://api.trakt.tv/user/watched/movies.json/valid/justin").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => fixture('watched_movies.json'))
    end

    context "without global user" do

      context "filling in 'justin'" do

        subject do
          @traktor.watched_movies('justin')
        end

        it "should find all movies" do
          subject.count.should == 7
        end

        it "should have invoked the URL" do
          subject # we'll have to explicitly call it ... meh
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched/movies.json/valid/justin")
        end

        it "should contain movie objects" do
          subject.each {|m| m.class.should == Traktor::Client::Movie }
        end

        it "should contain the proper data for the first movie" do
          subject[0].title.should == 'Despicable Me'
          subject[0].year.should == 2010
          subject[0].url.should == 'http://trakt.tv/movie/despicable-me-2010'
          subject[0].imdb_id.should == 'tt1323594'
          subject[0].tmdb_id.should == '50703'
        end

      end


      context "neglecting to fill in a username" do

        subject do
          @traktor.watched_movies
        end

        it "should throw NoUserException" do
          expect {subject}.to raise_error(Traktor::Client::NoUserException)
        end

      end

    end

    context "with global user" do

      before do
        @traktor.send('user=', 'justin') # this is something I picked up from a ruby ninja :o
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.watched_movies
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched/movies.json/valid/justin")
        end
      end

    end

  end

end