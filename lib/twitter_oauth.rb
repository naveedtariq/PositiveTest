class TwitterOauth

	def self.prepare_access_token(oauth_token, oauth_token_secret)
		consumer = OAuth::Consumer.new("d0IA5E2fjtmLOxR32CdKSw", "0ZbfD4X021fwZkEKVDO8v68GpmORTJH4W3OsqwBkY",
			{ :site => "http://api.twitter.com",
				:scheme => :header
			})
		# now create the access token object from passed values
		token_hash = { :oauth_token => oauth_token,
									 :oauth_token_secret => oauth_token_secret
								 }
		access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
		return access_token
	end
	

end
