# responsible for talking to API

class API

    def initialize(url)
        @url = url
    end

    def authenticate
        #current manually fetching a new access token when it expires... need to extend or automate this process
        access_token = ""
        refresh_token = ""
        @header = {
            "Authorization" => "Bearer #{access_token}"
            # These headers were mentioned in the API documentation, but looks like the request works fine without them
            #"Accept" => "application/json", 
            #"Content-Type" => "application/json"
        }
    end

    def response
        HTTParty.get(@url, headers: self.authenticate)
    end

    #doesnt seem like this step is needed with HTTParty
    def parse
        JSON.parse(response.body)
    end

end