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

        it "should contain the watched data for the first movie" do
          subject[0].watched?.should be_true
          subject[0].watched_at.should == Time.new(2011, 1, 10, 5, 42, 29)
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

  describe ".watched_episodes" do

    before do
      stub_request(:get, "http://api.trakt.tv/user/watched/episodes.json/valid/justin").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => fixture('watched_episodes.json'))
    end

    context "without global user" do

      context "filling in 'justin'" do

        subject do
          @traktor.watched_episodes('justin')
        end

        it "should have invoked the URL" do
          subject # we'll have to explicitly call it ... meh
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched/episodes.json/valid/justin")
        end

        it "should contain show objects" do
          subject.each {|o| o.is_a? Traktor::Client::Show} # doesn't realy work apparently ... sad
        end

        it "should find 2 distinct shows" do
          subject.count.should == 2
        end

        it "should contain the proper data for the first show" do
          subject[0].title.should == "Blue Mountain State"
          subject[0].url.should == "http://trakt.tv/show/blue-mountain-state"
          subject[0].imdb_id.should == "tt1344204"
          subject[0].tvdb_id.should == '134511'
        end

        it "should contain 2 episodes for the first show" do
          subject[0].episodes.count.should == 2
        end

        it "should contain 1 episodes for the second show" do
          subject[1].episodes.count.should == 1
        end

        it "should contain proper episode information for the first episode in the second show" do
          subject[1].episodes[0].title.should == "Past Transgressions"
          subject[1].episodes[0].url.should == "http://trakt.tv/show/spartacus-gods-of-the-arena/season/1/episode/1"
          subject[1].episodes[0].season.should == 1
          subject[1].episodes[0].number.should == 1
          subject[1].episodes[0].first_aired.should == Time.new(2011, 1, 21, 9)
        end

        it "should return the episodes as watched" do
          subject[0].episodes[0].watched?.should be_true
        end

      end

    end


    context "with global user" do

      before do
        @traktor.send('user=', 'justin')
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.watched_episodes
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched/episodes.json/valid/justin")
        end
      end

    end

  end


  describe ".watching" do
    context "without global user" do
      context "and user 'justin' not watching anything" do

        before do
          stub_request(:get, "http://api.trakt.tv/user/watching.json/valid/justin").
            with(:headers => {'Accept'=>'application/json'}).
            to_return(:status => 200, :body => fixture('watching_nothing.json'))
        end

        context "filling in 'justin'" do

          subject do
            @traktor.watching('justin')
          end

          it "should have invoked the URL" do
            subject # we'll have to explicitly call it ... meh
            WebMock.should have_requested(:get , "http://api.trakt.tv/user/watching.json/valid/justin")
          end

          it "should return nil" do
            subject.should be_nil
          end

        end
      end

      context "and user 'justin' is watching a movie" do

        before do
          stub_request(:get, "http://api.trakt.tv/user/watching.json/valid/justin").
            with(:headers => {'Accept'=>'application/json'}).
            to_return(:status => 200, :body => fixture('watching_movie.json'))
        end

        context "filling in 'justin'" do

          subject do
            @traktor.watching('justin')
          end

          it "should have invoked the URL" do
            subject # we'll have to explicitly call it ... meh
            WebMock.should have_requested(:get , "http://api.trakt.tv/user/watching.json/valid/justin")
          end

          it "should return a single movie object" do
            subject.should satisfy { |o| o.is_a? Traktor::Client::Movie }
          end

          it "should contain the correct info for the movie" do
            subject.title.should == 'Dinner for Schmucks'
            subject.url.should == 'http://trakt.tv/movie/dinner-for-schmucks-2010'
            subject.year.should == 2010
            subject.imdb_id.should == 'tt0427152'
            subject.tmdb_id.should == '38778'
          end

        end
      end

      context "and user 'justin' is watching aan episode" do

        before do
          stub_request(:get, "http://api.trakt.tv/user/watching.json/valid/justin").
            with(:headers => {'Accept'=>'application/json'}).
            to_return(:status => 200, :body => fixture('watching_episode.json'))
        end

        context "filling in 'justin'" do

          subject do
            @traktor.watching('justin')
          end

          it "should have invoked the URL" do
            subject # we'll have to explicitly call it ... meh
            WebMock.should have_requested(:get , "http://api.trakt.tv/user/watching.json/valid/justin")
          end

          it "should return a single show object" do
            subject.should satisfy { |o| o.is_a? Traktor::Client::Show }
          end

          it "should contain the correct info for the show" do
            subject.title.should == 'Community'
            subject.url.should == 'http://trakt.tv/show/community'
            subject.imdb_id.should == 'tt1439629'
            subject.tvdb_id.should == '94571'
          end

          it "should contain a single episode" do
            subject.episodes.count.should == 1
          end

          it "should contain correct data in the episode" do
            subject.episodes[0].title.should == 'Aerodynamics of Gender'
            subject.episodes[0].url.should == 'http://trakt.tv/show/community/season/2/episode/7'
            subject.episodes[0].season.should == 2
            subject.episodes[0].number.should == 7
            subject.episodes[0].first_aired.should == Time.new(2010, 11, 4, 8)
          end

        end
      end
    end


    context "with global user" do

      before do
        @traktor.send('user=', 'justin')
        stub_request(:get, "http://api.trakt.tv/user/watching.json/valid/justin").
          with(:headers => {'Accept'=>'application/json'}).
          to_return(:status => 200, :body => fixture('watching_nothing.json'))
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.watching
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watching.json/valid/justin")
        end

      end
    end
  end


  describe ".library_movies" do

    before do
      stub_request(:get, "http://api.trakt.tv/user/library/movies.json/valid/justin").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => fixture('library_movies.json'))
    end

    context "without global user" do

      context "filling in 'justin'" do

        subject do
          @traktor.library_movies('justin')
        end

        it "should have invoked the URL" do
          subject # we'll have to explicitly call it ... meh
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/library/movies.json/valid/justin")
        end

        it "should contain movie objects" do
          subject.each {|o| o.should satisfy { |o| o.is_a? Traktor::Client::Movie }}
        end

        it "should find 3 movies" do
          subject.count.should == 3
        end

        it "should register movies watched status correctly" do
          subject[0].watched?.should be_false
          subject[1].watched?.should be_true
          subject[2].watched?.should be_true
        end

        it "should contain the proper information for the first movie" do
          subject[0].title.should == '(500) Days of Summer'
          subject[0].year.should == 2009
          subject[0].url.should == 'http://trakt.tv/movie/500-days-of-summer-2009'
          subject[0].imdb_id.should == 'tt1022603'
          subject[0].tmdb_id.should == '19913'
        end

      end
    end

    context "with global user" do

      before do
        @traktor.send('user=', 'justin')
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.library_movies
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/library/movies.json/valid/justin")
        end
      end

    end

  end





  describe ".library_shows" do

    before do
      stub_request(:get, "http://api.trakt.tv/user/library/shows.json/valid/justin").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => fixture('library_shows.json'))
    end

    context "without global user" do

      context "filling in 'justin'" do

        subject do
          @traktor.library_shows('justin')
        end

        it "should have invoked the URL" do
          subject # we'll have to explicitly call it ... meh
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/library/shows.json/valid/justin")
        end

        it "should contain show objects" do
          subject.each {|o| o.should satisfy { |o| o.is_a? Traktor::Client::Show }}
        end

        it "should find 5 shows" do
          subject.count.should == 5
        end

        it "should contain the correct data for the first show" do
          subject[0].title.should == 'The Big Bang Theory'
          subject[0].url.should == 'http://trakt.tv/show/the-big-bang-theory'
          subject[0].year.should == 2007
          subject[0].imdb_id.should == 'tt0898266'
          subject[0].tvdb_id.should == '80379'
        end

      end
    end

    context "with global user" do

      before do
        @traktor.send('user=', 'justin')
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.library_shows
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/library/shows.json/valid/justin")
        end
      end

    end

  end



  describe ".watched" do

    before do
      stub_request(:get, "http://api.trakt.tv/user/watched.json/valid/justin").
        with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => fixture('watched.json'))
    end

    context "without global user" do

      context "filling in 'justin'" do

        subject do
          @traktor.watched('justin')
        end

        it "should have invoked the URL" do
          subject # we'll have to explicitly call it ... meh
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched.json/valid/justin")
        end

        it "should return 3 objects" do
          subject.count.should == 3
        end

        it "should contain show objects & movie objects" do
          subject[0].should satisfy { |o| o.is_a? Traktor::Client::Show }
          subject[1].should satisfy { |o| o.is_a? Traktor::Client::Show }
          subject[2].should satisfy { |o| o.is_a? Traktor::Client::Movie }
        end

        it "should group episodes in a single show" do
          subject[0].episodes.size.should == 2
        end

        it "should contain correct data for shows" do
          subject[0].title.should == 'Blue Mountain State'
          subject[0].url.should == 'http://trakt.tv/show/blue-mountain-state'
          subject[0].imdb_id.should == 'tt1344204'
          subject[0].tvdb_id.should == '134511'
        end

        it "should contain correct data for movies" do
          subject[2].title.should == 'Despicable Me'
          subject[2].url.should == 'http://trakt.tv/movie/despicable-me-2010'
          subject[2].imdb_id.should == 'tt1323594'
          subject[2].tmdb_id.should == '50703'
        end

        it "should return the watched dates for episodes" do
          subject[0].episodes[0].watched_at.should == Time.new(2011, 1, 26, 5, 27, 45)
          subject[0].episodes[1].watched_at.should == Time.new(2011, 1, 5, 4, 7, 36)
        end

        it "should return episodes as watched" do
          subject[0].episodes[0].watched?.should be_true
          subject[0].episodes[1].watched?.should be_true
        end

        it "should return movies as watched" do
          subject[2].watched?.should be_true
        end

        it "should return watched dates for movies" do
          subject[2].watched_at.should == Time.new(2011, 1, 10, 5, 42, 29)
        end
      end
    end

    context "with global user" do

      before do
        @traktor.send('user=', 'justin')
      end

      context "neglecting to fill in a username" do

        subject do
          @traktor.watched
        end

        it "should default to the global user" do
          subject
          WebMock.should have_requested(:get , "http://api.trakt.tv/user/watched.json/valid/justin")
        end
      end

    end

  end
end