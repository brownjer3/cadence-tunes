class User
    attr_accessor :name, :cadence, :playlists, :genres, :songs

    def initialize(name, user)
        @name = name

        @playlists = []
        @songs = []
    end

end