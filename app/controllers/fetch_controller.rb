class FetchController < ApplicationController

	def facebook
		User.find(:first).delay.fetch_facebook_feeds
		render :json => "job queued"
	end

	def twitter
		TwitterUser.delay.fetch_feeds
		render :json => "job queued"
	end

end
