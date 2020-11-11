class Genre
    attr_accessor :name, :id

    @@all = []

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



end