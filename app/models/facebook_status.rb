class FacebookStatus < ActiveRecord::Base

	belongs_to :friend

	def self.from_fb_json(fb_json, user_id, type)
		if FacebookStatus.find_by_unique_fb_id(fb_json["id"]).nil?
			status = FacebookStatus.new
			status.unique_fb_id = fb_json["id"]
			status.message = fb_json['message']
			status.friend_id = user_id
			status.raw_json = fb_json 
			status.feed_type = type
			status.save
			status
		else
			false
		end
	end

end
