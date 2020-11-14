class SpotifyObjCreator
    attr_accessor :response

    GENRE_URL = "https://api.spotify.com/v1/recommendations/available-genre-seeds"
    RECOMMENDATIONS_URL = "https://api.spotify.com/v1/recommendations?limit=10&market=us&seed_genres=#{@genre}&target_tempo=#{@tempo}"

    def self.access_genres
        #I guess I don't have to parse this because it's a simple array? 
        #UPDATE: I think spotify data just doesnt need to be parsed
        API.new(GENRE_URL).response
    end

    def self.create_genres
        self.access_genres["genres"].map do |g_id|
            name = g_id.gsub(/-/, " ").capitalize
            Genre.new(name, g_id)
        end
    end

    def self.access_recommendations(genre, tempo)
        url = "https://api.spotify.com/v1/recommendations?limit=100&market=us&seed_genres=#{genre}&target_tempo=#{tempo}"
        API.new(url).response
    end

    #i need to figure out how these arguments can best communicate with each other ^^
    def self.create_recommendations(genre, tempo)
        self.access_recommendations(genre, tempo)["tracks"].map do |t|
            Song.new("#{t["name"]}", genre, "#{t["id"]}", "#{t["artists"][0]["name"]}", tempo, "#{t["popularity"]}")
        end
    end

end