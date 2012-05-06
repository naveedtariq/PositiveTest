class User < ActiveRecord::Base

	has_many :facebook_statuses
	has_many :friends, :dependent => :destroy
  has_many :twitter_users, :dependent => :destroy


  def self.calculate_facebook
		Result.where(:user_type => 'facebook_friend').delete_all
		pw_hash = YAML.load_file("#{Rails.root}/config/pw.yml")["pw"]
		nw_hash = YAML.load_file("#{Rails.root}/config/nw.yml")["nw"]
		all_stats = {}
		allf = Friend.find(:all)
		scores = {}
		allf.each do |f|
			p_stats = []
			n_stats = []
			score = 0
			p_score = 0
			n_score = 0
			sts = f.facebook_statuses
			sts.each do |st|
				wrds = st.message.split
				wrds.each_with_index do |wrd, index|
					if (pw_hash.has_key?(wrd))
						found = {:word => wrd, :at => index+1, :status => (st.message.gsub(/\n/,"")).gsub(/\t/,"")}
						p_stats << found
						score = score + 1.0
						p_score = p_score + 1.0
					elsif (nw_hash.has_key?(wrd) )
						found = {:word => wrd, :at => index+1, :status => st.message}
						n_stats << found
						score = score - 1.0
						n_score = n_score + 1.0
					end
				end
			end
			has = {:positive_score => p_score, :negative_score => n_score, :ratio => (score/(f.facebook_statuses.count==0?1:f.facebook_statuses.count)), :messages_count => f.facebook_statuses.count, :score => score, :stats => {:positive => p_stats, :negative => n_stats} }
			all_stats[f.name] = has
			result = Result.new(:messages_count => f.facebook_statuses.count, :positive_score => p_score, :negative_score => n_score, :score => score, :stats_json => ActiveSupport::JSON.encode(has), :user_id => f.id, :user_type => 'facebook_friend')
			puts has.inspect + "-------------"
			result.save
		end
  end

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
    puts friends.inspect
		friends.each_with_index do |friend, index|
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

  def fetch_facebook_friends
		fb_access_token =	FbOauth.fb_access_token(fb_token)
		friends = JSON.parse(fb_access_token.get('/me/friends').body)
    puts friends.inspect
		save_all_friends(friends["data"])		
  end

end
