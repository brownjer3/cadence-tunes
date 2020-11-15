class Genre
    attr_accessor :name, :id

    @@all = []
    @@names = []

    def initialize(name, id)
        @name = name
        @id = id

        self.save
    end

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def self.find_by_id(genre)
        self.all.find {|s| s.id == genre}
    end

    def self.names
        Genre.all.collect {|g| g.name}
    end

    def self.display_genres
        pad = " "
        sorted = Genre.names.sort_by {|g| g.length}
        max = sorted[-1].length + 6
        width = `tput cols`.strip.to_i
        max_columns = (width / max) - 2
        current_col = 1
        Genre.all.each_with_index do |g, i|
            output_length = "[#{i+1}] #{g.name}".length
            buffer = (max - output_length) + 1
            if current_col <= max_columns
                print "[#{i+1}] #{g.name} #{pad.ljust(buffer)}"
                current_col += 1
            else
                puts "[#{i+1}] #{g.name} #{pad.ljust(buffer)}"
                current_col = 1
            end
        end
        puts " "
    end

    def songs
        Song.all.select {|s| s.genre == self.id}
    end

end