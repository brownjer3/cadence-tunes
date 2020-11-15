class Playlist
    attr_accessor :name, :songs

    @@all = []

    def initialize(name)
        @name = name
        @songs = []
        
        @@all << self
    end

    def self.all
        @@all
    end

    def self.display_all
        self.all.each_with_index do |p,i| 
            song_count = p.songs.count
            puts "[#{i+1}] #{p.name} - #{song_count} song(s)"
        end
    end

    def display_songs
        self.songs.each_with_index {|s,i| puts "[#{i+1}] #{s.name} - #{s.artist}"}
    end

    def add_song(song_obj)
        self.songs << song_obj
    end

    def add_song_by_name(name)
        song = Song.all.find {|s| s.name = name}
        self.songs << song
    end
    
end