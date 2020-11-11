class SpotifyObjCreator
    GENRE_URL = "https://api.spotify.com/v1/recommendations/available-genre-seeds"

    def self.access_genres
        API.new(GENRE_URL).response.parse
    end

    def self.create_genres
        self.access_genres["genres"].map do |g_id|
            name = g.gsub(/-/, " ").upcase
            Genre.new(name, g_id)
        end
    end

end