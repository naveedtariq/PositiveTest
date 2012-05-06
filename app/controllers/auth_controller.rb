class AuthController < ApplicationController


	def facebook
		redirect_to FbOauth.fb_client.auth_code.authorize_url(
				:redirect_uri => facebook_redirect_uri,
				:scope => 'read_stream,email,offline_access,friends_activities,friends_about_me,friends_status'
				)
	end

	def facebook_callback
		fb_access_token =	FbOauth.new_fb_token(params[:code], facebook_redirect_uri)
		user_info = JSON.parse(fb_access_token.get('/me').body)
		user = User.from_facebook_json(user_info, fb_access_token.token);
		@name = user.name
    user.fetch_facebook_friends
		redirect_to "/pages/home"
		#user.delay.fetch_facebook_statuses
	end

	def facebook_redirect_uri
		uri = URI.parse(request.url)
		uri.path = '/auth/facebook_callback'
		uri.query = nil
		uri.to_s
	end	
	
	def twitter
		TwitterOauth.twt_client.request_token(:oauth_callback => @twitter_redirect_uri).authorize_url
	end

	def twitter_callback
		twt_access_token =	TwitterOauth.new_twt_token(params[:code], twitter_redirect_uri)
		user_info = JSON.parse(twt_access_token.get('/me').body)
		user = User.from_twitter_json(user_info, twt_access_token.token);
		@name = user.name
#		user.delay.fetch_tweets
	end

	def twitter_redirect_uri
		uri = URI.parse(request.url)
		uri.path = '/auth/twitter_callback'
		uri.query = nil
		uri.to_s
	end	
end
