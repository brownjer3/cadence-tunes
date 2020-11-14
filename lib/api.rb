class API
    attr_accessor = :access_token

    def initialize(url)
        @url = url
    end

    def config
        JSON.parse(File.open("./bin/config.rb").read)
    end

    def authenticate
        binding.pry
        access_token = config["access_token"]
        @header = {
            "Authorization" => "Bearer #{access_token}"
        }
    end

    def refresh
        refresh_token = config["refresh_token"]
        encoded_id = config["client_encoded"]
        options = {
            headers: {
                "Authorization" => "Basic #{encoded_id}"
            },
            body: {
                "grant_type": "refresh_token",
                "refresh_token": "#{refresh_token}"
            }
        }
    end

    def refresh_response
        response = HTTParty.post("https://accounts.spotify.com/api/token", self.refresh)
        #binding.pry
        config["access_token"] = response["access_token"]
    end

    def response
        response = HTTParty.get(@url, headers: self.authenticate)
        #binding.pry
        if response["error"]["status"] != 200
            self.refresh_response
            HTTParty.get(@url, headers: self.authenticate)
        end
    end

    def parse
        JSON.parse(response.body)
    end

end