class TwitterUser < ActiveRecord::Base

	has_many :tweets

	def check_for_bandar(tweets)
		begin
			ret = false
			tweets.each do |tweet|
				time = Time.parse(tweet["created_at"]).to_i
				if(time > 1312156800 )
#					puts "ignored with time"+time.to_s
					next
				else 
					rr = {:tweet => tweet, :id => tweet["id_str"],:done => true, :time => tweet["created_at"]}
					return rr
				end
			end
			rr = {:tweet => tweets.last, :id => tweets.last["id_str"],:done => false, :time => tweets.last["created_at"]}
			return rr
		rescue Exception => exc
			logger.error(exc.backtrace)
			logger.error(exc.message)
			puts tweets.inspect
		end
	end

	def fetch_that_bandar
		that_id = nil
		done = false
		that_time = nil
		tweet = nil
		count = 0
		until done
			count = count + 1
			tweets = TweetFetcher.fetch_tweets(self.screen_name, that_id)		
			bandar = check_for_bandar(tweets)
			that_id = tweets.last["id_str"]
#			puts bandar.inspect
			done = bandar[:done]
			that_id = bandar[:id]
			that_time =  bandar[:time]
			tweet = bandar[:tweet]
		end
		self.beneficial_id =  that_id
		puts "----------------"+self.beneficial_id
		puts "That ID :" + that_id
		puts "Time :" + that_time
		puts "Tweet :" + tweet["text"]
		puts "User :" + self.screen_name
		self.save
		count
	end

	def self.fetch_those_ids
		count = 0
		begin
			twt_users = TwitterUser.find(:all)
			twt_users.each do |twt_user|
				unless twt_user.beneficial_id
					count = count + twt_user.fetch_that_bandar
				end
				puts "done..."

			end			
			puts "Request Count is : "+count
		rescue Exception => exc
			logger.error(exc.backtrace)
			 logger.error("Message for the log file #{exc.message}")
		end
	end

	def self.fetch_feeds
		begin
			twt_users = TwitterUser.find(:all)
			twt_users.each do |twt_user|
				unless twt_user.twt_fetched
					twt_user.fetch_all_tweets
				end
				puts "done..."
			end			
		rescue Exception => exc
			logger.error(exc.backtrace)
			 logger.error("Message for the log file #{exc.message}")
		end
	end

	def process_tweets(tweets)
		begin
			ret = false
			tweets.each do |tweet|
				time = Time.parse(tweet["created_at"]).to_i
				if(time > 1312156800 )
					puts "ignored with time"+time.to_s
					next
				end
				if(time < 1309478400)
					ret = true
					puts "breaking at time"+time.to_s
					break
				end
				Tweet.from_twitter_json(tweet, self.id)	
				puts "stored with time"+time.to_s
				if (tweets.size == 1)
					ret= true
					break
				end
			end
			return ret
		rescue Exception => exc
			logger.error(exc.backtrace)
			logger.error(exc.message)
			puts tweets.inspect
		end
	end


	def fetch_all_tweets
		max_id = self.beneficial_id
		done = false
		until done
			tweets = TweetFetcher.fetch_tweets(self.screen_name, max_id)		
			done = process_tweets(tweets)
			new_max_id = tweets.last["id_str"]
			if(new_max_id == max_id)
				break
			end
			max_id = new_max_id
		end
		self.twt_fetched =  true
		self.save
	end

end
