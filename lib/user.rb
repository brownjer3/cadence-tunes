class User
    attr_accessor :name, :playlists

    def initialize(name)
        @name = name
        @playlists = []
    end

end