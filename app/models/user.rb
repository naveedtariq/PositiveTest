class User < ActiveRecord::Base

	has_many :facebook_statuses
	has_many :friends

	def self.from_facebook_json(fb_json, token)
		u = User.new
		u.email = fb_json["email"]
		u.name = fb_json["name"]
		u.facebook_id = fb_json["id"]
		u.fb_token = token

		u.save
		u
	end


	def save_all_friends(friends)
		friends.each_with_index do |friend, index|
			if index == 49
				break
			end
			frind = Friend.new(:fb_id => friend["id"], :name => friend["name"], :user_id => self.id)
			frind.save	
		end	
		frind = Friend.new(:fb_id => self.facebook_id, :name => self.name, :user_id => self.id)
		frind.save
	end


	def fetch_facebook_feeds
		fb_users = self.friends
		fb_users.each do |fb_user|
			fb_user.fetch_facebook_feeds	
		end			
	end

	def postive_score
		a = {"shit" => true, "waj" => true, "all" => true, "Naveed" => true}
		all = self.facebook_statuses
		count = 0
		all.each do |one|
			wrds = one.message.split(" ")
			wrds.each do |wrd|
				if(a[wrd])
					count = count + 1
				end
			end
		end
		count
	end

end
