class Song
    attr_accessor :name, :id, :artist, :genre, :playcount

    # users?? playlists??

    def initiliaze(name, id, artist, genre, playcount)
        @name = name
        @artist = artist
        @genre = genre
        @playcount = playcount
    end

end