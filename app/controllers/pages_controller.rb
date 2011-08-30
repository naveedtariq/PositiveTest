class PagesController < ApplicationController

	def index
		if User.find(:first)
			redirect_to "/pages/home"
		end
	end

	def home
		@name = User.find(:first).name
		@fb_complete = (Friend.where(:fb_fetched => true).count == Friend.count)
		@twt_complete = (TwitterUser.where(:twt_fetched => true).count == TwitterUser.count)
	end

end
