class Song
    attr_accessor :name, :genre, :id, :artist, :popularity

    @@all = []

    def initialize(name, genre, id, artist, popularity)
        @name = name
        @genre = genre
        @artist = artist
        @popularity = popularity

        @@all << self
    end

    def self.all
        @@all.sort_by {|s| s.popularity}.reverse
    end

    def self.find_by_genre(genre)
        songs = self.all.select {|s| s.genre == genre}
    end

    def self.display_ranked_songs_by_genre(genre, x)
        songs = self.find_by_genre(genre)
        if x < songs.length
            songs[(x-9)..x].each_with_index {|s, i| puts "[#{i+1}] #{s.name} --- #{s.artist}"}
        end
    end

    def add_to_playlist(playlist_obj)
        playlist_obj.songs << self
    end


end