class ScoresController < ApplicationController


	def top_facebook
		rs = Result.where(:user_type => 'facebook_friend').order('score DESC').limit(10)
		arr = []
		rs.each do |r|
			arr << [r.score, Friend.find(r.user_id).name] 	
		end
		render :json => arr.reverse.to_json
	end

	def top_twitter
	end

	def why
		render :json=> Result.find(params[:rs_id]).stats_json
	end


	def index
		@facebook_results = Result.where(:user_type => 'facebook_friend').order('score DESC')
		@twitter_results = Result.where(:user_type => 'twitter_user').order('score DESC')
	end

	def facebook
		pw_hash = YAML.load_file("#{RAILS_ROOT}/config/pw.yml")["pw"]
		nw_hash = YAML.load_file("#{RAILS_ROOT}/config/nw.yml")["nw"]
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
		redirect_to '/scores/'	
	end

	def twitter
		pw_hash = YAML.load_file("#{RAILS_ROOT}/config/pw.yml")["pw"]
		nw_hash = YAML.load_file("#{RAILS_ROOT}/config/nw.yml")["nw"]
		all_stats = {}
		allf = TwitterUser.find(:all)
		scores = {}
		allf.each do |f|
			p_stats = []
			n_stats = []
			score = 0
			p_score = 0
			n_score = 0
			sts = f.tweets
			sts.each do |st|
				wrds = st.message.split
				wrds.each_with_index do |wrd, index|
					if (pw_hash.has_key?(wrd))
						found = {:word => wrd, :at => index+1, :status => st.message}
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
			has = {:positive_score => p_score, :negative_score => n_score, :ratio => (score/(f.tweets.count==0?1:f.tweets.count)), :messages_count => f.tweets.count, :score => score, :stats => {:positive => p_stats, :negative => n_stats} }
			all_stats[f.screen_name] = has
			result = Result.new(:messages_count => f.tweets.count, :positive_score => p_score, :negative_score => n_score, :score => score, :stats_json => ActiveSupport::JSON.encode(has), :user_id => f.id, :user_type => 'twitter_user')
			result.save
		end
		
		redirect_to '/scores/'	
	end

end
