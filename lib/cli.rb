# command line interface, interact with user and connect files together

class CLI
    attr_accessor :cadence, :genre_id, :genre, :user

    def start
        welcome
        get_cadence
        genre_selection
        display_recommended_songs
        main_loop
    end

    def welcome
        #also want to put in an informative line on the link b/t BPM and run cadence 
        puts "     __O        __O        __O         "
        puts "    / /\\_,     / /\\_,     / /\\_,    "
        puts "  ___/\\      ___/\\      ___/\\       "
        puts " /    /_    /    /_    /    /_         " 
        puts "Welcome to Candence Tunes!"
    end

    #i probably won't have time for this, but it'd be cool to remember users and their playlist info
    # def create_user(input)
    #     User.new(input)
    # end

    def main_loop
        song_options
    end

    def song_options
        # to be used when viewing the list of songs
        puts " "
        puts "****************************************************"
        puts "Enter a song number to add to playlist"
        puts "             *** OR ***               "
        puts "'m' To view more recommended songs in this Genre"
        #puts "'l' To list the recommended songs again"
        puts "'d' To pick a different Genre"
        puts "'e' To exit"
        puts "****************************************************"

        input = gets.strip

        if input.to_i.between?(1,10)
            song_index = input.to_i - 1
            playlist = add_to_playlist(song_index)
            playlist.display_songs
        elsif input == "m"
            #to view more songs in this genre
            #should remove the song that was just added - TO-DO
            puts "NOT FINISHED HERE!!"
        elsif input == "d"
            # to pick a different genre
            genre_selection
            main_loop
        end

        until input == "e"
            main_loop
        end
    end

    def playlist_options
        input = gets.strip

        if input == "b"
            #back to list of recommended songs
            
        elsif input == "m"
            #to view more songs in this genre
            #should remove the song that was just added - TO-DO
            puts "NOT FINISHED HERE!!"
        elsif input == "d"
            # to pick a different genre
            genre_selection
            main_loop
        end
    end

    def get_cadence
        puts "What is your desired running cadence? (steps/minute)"
        input = gets.strip
        if !input.to_i.between?(90,250)
            print "Please enter a valid cadence (90-250). Most runners aim for ~180. "
            self.get_cadence
        end
        @cadence = input
    end

    def genre_selection
        puts @genre_id.nil? ? "Awesome! And what Genre of music do you like to run to?" : "Select a new Genre: "
        self.display_genres
        input = gets.strip
        self.select_genre(input)
    end

    def display_genres
        puts "****************************************"
        puts "*                                      *"
        puts "*            List of Genres            *"
        puts "*                                      *"
        puts "****************************************"
        # Convert to Ternary
        if Genre.all.empty?
            SpotifyObjCreator.create_genres
        end
        Genre.display_genres
    end

    def select_genre(input)
        index = input.to_i - 1
        if index.between?(0,display_genres.length)
            @genre = Genre.all[index]
            @genre_id = Genre.all[index].id
            if self.genre.songs.empty?
                SpotifyObjCreator.create_recommendations(@genre_id, @cadence)
            end
        else
            "Please select a valid option"
        end
    end

    def display_recommended_songs(x=9)
        puts "****************************************"
        puts "*                                      *"
        puts "*          Recommended Songs           *"
        puts "*                                      *"
        puts "****************************************"

        # Convert to Ternary

        genre = Genre.all.find {|g| g.id == @genre_id}

        #problem here vvv
        genre.print_10_songs(x)

        # if i have time, will want to add in a "view more info step here"
        # also maybe i can quickly add in an option to add all songs into the playlist
    end

    def add_to_playlist(song_index)
        playlist = self.find_or_create_playlist
        playlist.add_song(self.genre.songs[song_index])
        playlist
    end

    def create_playlist
        puts "Nice choice! Since you don't have any playlists yet, let's make one. Please give your new playlist a name: "
        input = gets.strip
        playlist = Playlist.new(input)
        puts "Your new '#{input}' playlist was just created!"
        playlist
    end

    def find_playlist
        Playlist.display_all
        puts "Please enter the number of the playlist to add this song to:"
    end

    def select_playlist
        find_playlist
        input = gets.strip
        index = input.to_i - 1
        Playlist.all[index]
    end

    def find_or_create_playlist
        if Playlist.all.empty?
            create_playlist
        else
            select_playlist
        end
    end
end