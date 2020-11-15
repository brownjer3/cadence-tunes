# Cadence Tunes
Cadence Tunes is a CLI program built with Ruby to create running playlists based on song tempo. The program connects to the Spotify API to retreive music data that the user can browse through. 

The program asks the user to provide their desired running cadence (steps/minute). They're then shown a list of Spotify's seed genres (genres that can be used to provide song recommendations) and asked to select the one they'd like to run to. From there, the program retreives the recommended songs from Spotify and displays them in order of popularity. The user can then choose to add a song to a playlist, browse for more songs, or change any of the information they've previously provided. 

# Setting up Cadence Tunes
In order to use Cadence Tunes you need to...

* Know your desired running cadence! Take a jog at your desired pace and count the number of steps you take in a minute. 
* Install Ruby
* Clone the repo
* Install all required gems (Bundle Install)
* Request authorization from Spotify (https://developer.spotify.com/documentation/general/guides/authorization-guide/)
  * Store client_id, client_secrete, access_token & refresh_token as a hash in a hidden /bin/config file
  
# Getting your tunes
Start by running 
```ruby bin/run                                                                                                                                ```
And then follow the prompts to provide your desired running cadence, the genre of music that you like to run to, and select songs to add to your playlists! You can edit your target cadence or preferred music genre at any time. 
