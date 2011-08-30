class TweetFetcher

	include HTTParty
	base_uri 'http://api.twitter.com/'
	format :json

	def self.fetch_tweets(screen_name, max_id = nil)

		token = TwitterOauth.prepare_access_token('228644622-N6BRXR8aNQFrJBbH5N533VAf2xMgOo5MYInoyiAh','OJuAv5g25jv1zIvtX4RULANmdyX4BS7tUpmcszlSE')
		req_str = "/1/statuses/user_timeline.json?screen_name=#{screen_name}&trim_user=true&include_entities=false&count=200&include_rts=1"
		if max_id
			req_str = req_str + "&max_id=#{max_id}"
		end
		tweets = JSON.parse(token.get(req_str).body)
	end

end
