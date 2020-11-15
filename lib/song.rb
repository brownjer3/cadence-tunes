class Song
    attr_accessor :name, :genre, :id, :artist, :tempo, :popularity

    @@all = []

    def initialize(name, genre, id, artist, tempo, popularity)
        @name = name
        @genre = genre
        @id = id
        @artist = artist
        @tempo = tempo
        @popularity = popularity

        @@all << self
    end

    def self.all
        @@all
    end

    def self.find_by_genre_and_tempo(genre, tempo)
        self.all.select {|s| s.genre == genre && s.tempo == tempo}
    end

    def self.display_10_songs(arr, x)
        arr.each_with_index do |s,i| 
            if i.between?(x-9, x)
                puts "[#{i+1}] #{s.name} --- #{s.artist}"
            end
        end
        puts " "
    end

    def add_to_playlist(playlist_obj)
        playlist_obj.songs << self
    end
    
end