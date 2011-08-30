class FbOauth

	def self.fb_client
		@fb_client ||= OAuth2::Client.new('176485969058177', 'd5883469ab10f4752067ea15b9aabf8d',
		:token_url => "/oauth/access_token", :site => 'https://graph.facebook.com', :raise_errors => false)
	end


	def self.new_fb_token(code, redirect_uri)
		@fb_access_token = fb_client.auth_code.get_token(code, :parse => :query, :redirect_uri => redirect_uri)
		@fb_access_token.options[:mode] = :query
		@fb_access_token.options[:param_name] = "access_token"
		@fb_access_token.options[:header_format] = ""
		@fb_access_token
	end

	def	self.fb_access_token(token)
		@fb_access_token = OAuth2::AccessToken.new(fb_client, token)
		@fb_access_token.options[:mode] = :query
		@fb_access_token.options[:param_name] = "access_token"
		@fb_access_token.options[:header_format] = ""
		@fb_access_token
	end
	

end
