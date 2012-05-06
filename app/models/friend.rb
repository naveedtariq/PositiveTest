class Friend < ActiveRecord::Base
	belongs_to :user
	has_many :facebook_statuses


	def fetch_facebook_feeds
		unless self.fb_fetched
      t_untill = Time.now.to_i
      since = t_untill - 2592000
      req_uri = "/#{self.fb_id}/statuses?since=#{since}&until=#{t_untill}"
      puts req_uri.inspect
			statuses = 	FbOauth.fb_access_token(self.user.fb_token).get(req_uri).body
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
