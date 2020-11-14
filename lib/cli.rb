
class CLI
    attr_accessor :cadence, :genre_id, :genre, :x

    # --------------------------  GENERAL METHODS -------------------------- #

    def start
        #might want to rename the #x instance variable
        @x = 9
        welcome
        get_cadence
        genre_selection
        display_recommended_songs
        song_options
    end

    def welcome
        #also want to put in an informative line on the link b/t BPM and run cadence 
        puts "     __O        __O        __O         "
        puts "    / /\\_,     / /\\_,     / /\\_,    "
        puts "  ___/\\      ___/\\      ___/\\       "
        puts " /    /_    /    /_    /    /_         " 
        puts "Welcome to Candence Tunes!"
    end

    # def main_loop
    #     display_recommended_songs
    #     song_options
    # end

    def exit_program
        puts "Thanks for using Cadence Tunes!"
    end

    def error(text)
        ap "#{text}", options = {color: {string: :red}}
    end

    # --------------------------  OPTIONS -------------------------- #

    def main_options
        puts "'c' To change desired cadence"
        puts "'d' To view a different genre"
        puts "'e' To exit"

        input = gets.strip

        if input.to_i.between?(1,10)
            song_index = input.to_i - 1
            playlist = add_to_playlist(song_index)
            display_playlist(playlist)
            playlist_options
        elsif input == "c"
            change_cadence
            main_loop
        elsif input == "d"
            genre_selection
            display_recommended_songs
            song_options
        elsif input == "m"
            #should remove the song that was just added - TO-DO
            @x+=10
            more_songs(@x)
            song_options
        elsif input == "b"
            @x-=10
            back_page(@x)
            song_options
        elsif input == "l"
            display_recommended_songs
            song_options
        elsif input == "p"
            find_playlist
            view_playlist_options
        elsif input == "e"
            exit_program
        end   
        
    end

    def song_options
        puts " "
        puts "Enter a song number to add to playlist"
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
        puts "Enter the number of the playlist to view all songs"
        main_options
    end

    # --------------------------  CADENCE -------------------------- #

    def get_cadence
        puts "What is your desired running cadence? (steps/minute)"
        input = gets.strip.to_i
        if !input.to_i.between?(90,250)
            print "Please enter a valid cadence (90-250). Most runners aim for ~180. "
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

    def genre_selection
        self.display_genres
        print @genre_id.nil? ? "And what genre of music do you like to run to?" : "Select a new genre: "
        input = gets.strip
        index = input.to_i - 1
        until index.between?(0, Genre.all.length) 
            error("Please select a valid genre")
            input = gets.strip
            index = input.to_i - 1            
        end
        self.select_genre(index)
    end

    def display_genres
        puts "****************************************************"
        puts "*                                                  *"
        puts "*                 List of Genres                   *"
        puts "*                                                  *"
        puts "****************************************************"
        # Convert to Ternary
        if Genre.all.empty?
            SpotifyObjCreator.create_genres
        end
        sleep(0.5)
        Genre.display_genres
    end

    def select_genre(index)
        @genre = Genre.all[index]
        @genre_id = Genre.all[index].id
        if self.genre.songs.empty?
            SpotifyObjCreator.create_recommendations(@genre_id, @cadence)
        end
    end

    # --------------------------  RECOMMENDATIONS -------------------------- #

    def find_songs
        Song.find_by_genre_and_tempo(@genre_id, @cadence)
    end

    def display_recommended_songs
        songs = find_songs
        puts "****************************************"
        puts "*                                      *"
        puts "*          Recommended Songs           *"
        puts "*                                      *"
        puts "****************************************"

        songs[0..9].each_with_index do |s,i| 
            puts "[#{i+1}] #{s.name} -- #{s.artist}"
        end
    end

    def more_songs(x)
        songs = find_songs
        songs[(x-9..x)].each_with_index do |s,i| 
            i+=x
            puts "[#{i+1}] #{s.name} -- #{s.artist}"
        end
    end

    def back_page(x)
        songs = find_songs
        songs[(x-9..x)].each_with_index do |s,i| 
            i+=x
            puts "[#{i+1}] #{s.name} -- #{s.artist}"
        end
    end

    # --------------------------  PLAYLIST -------------------------- #


    def add_to_playlist(song_index)
        playlist = self.find_or_create_playlist
        playlist.add_song(self.genre.songs[song_index])
        playlist
    end

    def create_playlist
        puts " "
        puts "Nice choice! Since you don't have any playlists yet, let's make one. " if Playlist.all.empty?
        print "Please give your new playlist a name: "
        input = gets.strip
        playlist = Playlist.new(input)
        puts "Your new '#{input}' playlist was just created!"
        playlist
    end

    def display_playlist(playlist)
        playlist.display_songs
    end

    def find_playlist
        Playlist.display_all
        print "Please enter the number of the playlist to select: "
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
