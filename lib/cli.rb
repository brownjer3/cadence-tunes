# command line interface, interact with user and connect files together

class CLI

    def initialize
        self.welcome
        self.pick_genre
        self.select_genre(@input)
    end

    def welcome
        #need to change the title and add some cool intro design for the program!!!
        puts ap "Welcome to Candence Tunes!"
    end

    def pick_genre
        puts "What genre of music do you like to run to?"
        self.display_10_genres
        #binding.pry
        input = gets.strip
        self.select_genre(input)
    end

    def display_10_genres
        binding.pry
    end

    def select_genre(input)
        index = input.to_i - 1
        display_genres[index]
        #binding.pry
    end



end