class PositivityTestAPI < ActionWebService::API::Base

  class AnalysisResult< ActionWebService::Struct
    member :positive_score, :integer
    member :negative_score, :integer
    member :total_score, :integer
    member :stats, :string
  end

  api_method :facebook_analysis, :expects => [{:name => :string}, {:email => :string}, {:facebook_id => :string}, {:facebook_token => :string}], :returns => [:string]

  api_method :twitter_analysis, :expects => [{:api_id => :integer}, {:twitter_names => :string}], :returns => [:string]

  api_method :my_facebook_analysis, :expects => [{:api_id => :integer}], :returns => [AnalysisResult]

end
