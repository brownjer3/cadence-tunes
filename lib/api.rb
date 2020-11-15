class API
    attr_accessor = :access_token

    FILE = "./bin/config.rb"

    def initialize(url)
        @url = url
    end

    def config
        JSON.parse(File.read(FILE))
    end

    def authenticate
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
        new_token = response["access_token"]
        text = File.read(FILE)
        new_data = text.gsub(/#{config["access_token"]}/, "#{new_token}")
        File.write("./bin/config.rb", new_data)
    end

    def response
        response = HTTParty.get(@url, headers: self.authenticate)
        if response.include?("error")
            self.refresh_response
        end
        HTTParty.get(@url, headers: self.authenticate)
    end

    def parse
        JSON.parse(response.body)
    end

end