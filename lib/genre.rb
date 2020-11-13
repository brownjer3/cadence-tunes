class Genre
    attr_accessor :name, :id

    @@all = []

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

    def self.display_genres
        Genre.all.each_with_index {|g, i| puts "[#{i+1}] #{g.name}"}
        
        # Need to organize this nicely!!!  
        # 10.times do |i|
        #     puts Genre.all[i].name
        # end
    end

    # def self.display_next_genres(x,y)
    #     x.upto(y) do |i|
    #         puts Genre.all[i].name
    #     end
    # end

    def print_10_songs(x=9)
        # 10 at a time for readability
        self.songs[(x-9..x)].each_with_index {|s,i| puts "[#{i+1}] #{s.name} --- #{s.artist}" }
        x+=10
    end

    def find_by_index(index)
        self.songs[index]
    end



end