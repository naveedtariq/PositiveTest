class StatusController < ApplicationController

	def facebook
		total = User.find(:first).friends.count 			
		fetched = User.find(:first).friends.where(:fb_fetched => true).count
		statuses = FacebookStatus.count
		render :json => {:total => total, :fetched => fetched, :statuses => statuses}.to_json
	end

	def twitter
		total = TwitterUser.count
		fetched = TwitterUser.where(:twt_fetched => true).count
		tweets = Tweet.count
		render :json => {:total => total, :fetched => fetched, :tweets => tweets}.to_json
	end

	def calculate__facebook_scores
		hash = YAML.load_file("#{RAILS_ROOT}/config/pw.yml")["pw"]
		all_stats = {}
		allf = Friend.find(:all)
		scores = {}
		allf.each do |f|
			stats = {}
			score = 0
			sts = f.facebook_statuses
			sts.each do |st|
				wrds = st.message.split
				wrds.each_with_index do |wrd, index|
					if (hash.has_key?(wrd))
						stats[wrd] = st.message
						score = score + 1.0
					end
				end
			end
			has = {:score => score, :stats => stats}
			all_stats[f.name] = has
		end
		
		render :json => all_stats.to_json
	end

	def calculate_twitter_scores
		hash = YAML.load_file("#{RAILS_ROOT}/config/pw.yml")["pw"]
		all_stats = {}
		allf = TwitterUser.find(:all)
		scores = {}
		allf.each do |f|
			stats = []
			score = 0
			sts = f.tweets
			sts.each do |st|
				wrds = st.message.split
				wrds.each_with_index do |wrd, index|
					if (hash.has_key?(wrd))
						found = {:word => wrd, :at => index+1, :status => st.message}
						stats << found
						score = score + 1.0
					end
				end
			end
			has = {:ratio => (score/(f.tweets.count==0?1:f.tweets.count)), :messages_count => f.tweets.count, :score => score, :stats => stats }
			all_stats[f.screen_name] = has
		end
		
		render :json => all_stats.to_json
	end
end
