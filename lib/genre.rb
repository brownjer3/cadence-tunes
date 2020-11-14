class Genre
    attr_accessor :name, :id

    @@all = []
    @@names = []

    def initialize(name, id)
        @name = name
        @id = id

        self.save
        @index = 0
    end

    def self.all
        @@all
    end

    def save
        @@all << self
    end

    def self.find_by_id(genre)
        genre = self.all.find {|s| s.id == genre}
    end

    def songs
        Song.all.select {|s| s.genre == self.id}
    end

    def self.names
        Genre.all.collect {|g| g.name}
    end

    def self.display_genres
        # binding.pry
        pad = " "
        sorted = Genre.names.sort_by {|g| g.length}
        max = sorted[-1].length + 6
        #binding.pry
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

    # def self.display_next_genres(x,y)
    #     x.upto(y) do |i|
    #         puts Genre.all[i].name
    #     end
    # end

    # def print_10_songs(x=9)
    #     # 10 at a time for readability
    #     self.songs[(x-9..x)].each_with_index {|s,i| puts "[#{i+1}] #{s.name} --- #{s.artist}" }
    #     x+=10
    # end

    def find_by_index(index)
        self.songs[index]
    end



end