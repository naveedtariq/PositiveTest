class Friend < ActiveRecord::Base
	belongs_to :user
	has_many :facebook_statuses


	def fetch_facebook_feeds
		unless self.fb_fetched
			statuses = 	FbOauth.fb_access_token(self.user.fb_token).get("/#{self.fb_id}/statuses?since=1309478400&until=1312156800").body
			statuses = JSON.parse(statuses);
			unless statuses["data"].nil?
				statuses["data"].each do |status|
					puts "next"
					FacebookStatus.from_fb_json(status, self.id, "status")
					if(status["comments"])
						comments = status["comments"]["data"]
						comments.each do |comment|
							from = comment["from"]["id"]	
							friend = Friend.find_by_fb_id(from)
							if friend
								FacebookStatus.from_fb_json(comment, friend.id, "comment")
							end
						end
					end
				end
			end
			self.fb_fetched = true
			self.save
		end
	end

end
