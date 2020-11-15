
class CLI
    attr_accessor :cadence, :genre_id, :genre, :x

    # --------------------------  GENERAL METHODS -------------------------- #

    def start
        @x = 9
        welcome
        get_cadence
        genre_selection
        display_recommended_songs
        song_options
    end

    def welcome
        puts "     __O        __O        __O         ".purple
        puts "    / /\\_,     / /\\_,     / /\\_,    ".purple
        puts "  ___/\\      ___/\\      ___/\\       ".purple
        puts " /    /_    /    /_    /    /_         ".purple
        puts " "
        puts "   Welcome to Candence Tunes!".purple
        puts " "
        sleep(0.5)
    end

    def exit_program
        puts "Thanks for using Cadence Tunes!".purple
    end

    def error(text)
        puts text.red
    end

    def main_choice(text)
        print text.green
    end

    # --------------------------  OPTIONS -------------------------- #

    def main_options
        puts "'c' To change desired cadence"
        puts "'g' To view a different genre"
        puts "'e' To exit"

        input = gets.strip

        if input.to_i.between?(@x-8,@x-1)
            select_song(input)
        elsif input == "c"
            change_cadence
            display_recommended_songs
            song_options
        elsif input == "g"
            change_genre
            display_recommended_songs
            song_options
        elsif input == "m"
            @x+=10
            display_recommended_songs
            song_options
        elsif input == "b"
            @x-=10
            display_recommended_songs
            song_options
        elsif input == "l"
            display_recommended_songs
            song_options
        elsif input == "p"
            view_playlist_options
        elsif input == "e"
            exit_program
        end   
        
    end

    def song_options
        main_choice("Enter a song number to add to playlist")
        puts " "
        puts "*** OR *** "
        puts "'m' To view more recommended songs in this genre"
        puts "'b' To go back to the previous page"
        main_options
    end

    def playlist_options
        puts " "
        puts "'l' To return to list of songs"
        puts "'p' To view all playlists"
        main_options
    end

    def view_playlist_options
        puts " "
        playlist = select_playlist
        display_playlist(playlist)
        playlist_options
    end

    # --------------------------  CADENCE -------------------------- #

    def get_cadence
        main_choice("What is your desired running cadence? (steps/minute) ")
        input = gets.strip.to_i
        if !input.to_i.between?(90,250)
            error("Please enter a valid cadence (90-250). Most runners aim for ~180. ")
            self.get_cadence
        end
        @cadence = input
    end

    def change_cadence
        @x=9
        get_cadence
        SpotifyObjCreator.create_recommendations(@genre_id, @cadence)
    end

    # --------------------------  GENRE -------------------------- #

    def genre_header
        puts "****************************************************"
        puts "*                                                  *"
        puts "*                 List of Genres                   *"
        puts "*                                                  *"
        puts "****************************************************"
    end

    def display_genres
        genre_header
        if Genre.all.empty?
            SpotifyObjCreator.create_genres
        end
        sleep(0.5)
        Genre.display_genres
    end

    def genre_selection
        display_genres
        @genre_id.nil? ? main_choice("Enter the number of the genre that you like to run to: ") : main_choice("Select a new genre: ")
        index = gets.strip.to_i - 1
        until index.between?(0, Genre.all.length) do
            error("Please select a valid genre")
            index = gets.strip.to_i - 1           
        end
        select_genre(index)
    end

    def select_genre(index)
        @genre = Genre.all[index]
        @genre_id = Genre.all[index].id
        if self.genre.songs.empty?
            SpotifyObjCreator.create_recommendations(@genre_id, @cadence)
        end
    end

    def change_genre
        @x=9
        genre_selection
    end

    # --------------------------  RECOMMENDATIONS -------------------------- #

    def find_songs
        Song.find_by_genre_and_tempo(@genre_id, @cadence)
    end

    def song_header
        puts "****************************************"
        puts "*                                      *"
        puts "*          Recommended Songs           *"
        puts "*                                      *"
        puts "****************************************"
    end

    def display_recommended_songs
        songs = find_songs
        song_header
        Song.display_10_songs(songs, @x)
    end

    def select_song(input)
        song_index = input.to_i - 1
        playlist = add_to_playlist(song_index)
        display_playlist(playlist)
        playlist_options
    end

    # --------------------------  PLAYLIST -------------------------- #

    def playlist_header
        puts "****************************************"
        puts "*                                      *"
        puts "*           Your Playlists             *"
        puts "*                                      *"
        puts "****************************************"
    end

    def add_to_playlist(song_index)
        playlist = self.find_or_create_playlist
        playlist.add_song(self.genre.songs[song_index])
        playlist
    end

    def create_playlist
        puts " "
        main_choice("Nice choice! Since you don't have any playlists yet, let's make one. ") if Playlist.all.empty?
        main_choice("Please give your new playlist a name: ")
        input = gets.strip
        playlist = Playlist.new(input)
        puts "Your new '#{input}' playlist was just created!"

        playlist
    end

    def display_playlist(playlist)
        puts " "
        puts "Your '#{playlist.name}' playlist includes:".purple
        puts "************************************************************"
        playlist.display_songs
        puts "************************************************************"
    end

    def find_playlist
        playlist_header
        Playlist.display_all
        main_choice("Please enter the number of the playlist to select: ")
    end

    def select_playlist
        find_playlist
        index = gets.strip.to_i - 1
        Playlist.all[index]
    end

    def find_or_create_playlist
        if Playlist.all.empty?
            create_playlist
        else
            if Playlist.all.count == 1
                puts "'a' To add to your '#{Playlist.all[0].name}' playlist"
            else
                puts "'a' To add to an existing playlist"
            end
            puts "'n' To create new playlist"
            input = gets.strip
            if input == "a" && Playlist.all.count == 1
                Playlist.all[0]
            elsif input == "a" 
                select_playlist
            elsif input == "n"
                create_playlist
            else
                puts "Please enter 'a' or 'n'"
                find_or_create_playlist
            end
        end
    end
end
