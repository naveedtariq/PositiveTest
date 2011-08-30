class Tweet < ActiveRecord::Base
	belongs_to :twitter_user

	def self.from_twitter_json(twt_json, twitter_user_id)
		unless Tweet.find_by_unique_twitter_id(twt_json["id_str"])
			tweet = Tweet.new(:raw_json => twt_json, :twitter_user_id => twitter_user_id, :message => twt_json["text"], :unique_twitter_id => twt_json["id_str"])
		tweet.save
		end	
	end
end
