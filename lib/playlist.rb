class Playlist
    attr_accessor :name, :songs, :user

    @@all = []

    def initialize(name, user=nil)
        @name = name
        @user = user
        @songs = []
        
        @@all << self
    end

    def self.all
        @@all
    end

    def self.display_all
        self.all.each_with_index {|p,i| puts "[#{i+1}] #{p.name}"}
    end

    def display_songs
        puts " "
        puts ap "Your '#{self.name}' playlist includes:"
        puts "************************************************************"
        self.songs.each_with_index {|s,i| puts "[#{i+1}] #{s.name} - #{s.artist}"}
        puts "************************************************************"
    end

    def add_song(song_obj)
        self.songs << song_obj
    end

    def add_song_by_name(name)
        song = Song.all.find {|s| s.name = name}
        self.songs << song
    end

    

end