class PositivityTestController < ApplicationController
  acts_as_web_service
  web_service_api PositivityTestAPI
  web_service_scaffold :invoke

  def facebook_analysis
    u = User.create(:name => params[:name], :email => params[:email], :facebook_id => params[:facebook_id], :fb_token => params[:facebook_token])
    return "Failed - #{u.errors.to_json.to_s}" unless u.errors.empty?
    u.delay.fetch_facebook_friends
    "Success - Your API id = #{u.id}"
  end

  def twitter_analysis
    params[:twitter_names].split(",").each do |tu|
      TwitterUser.create(:screen_name => tu, :user_id => params[:api_id])
    end
    return "Success"
  end

  def my_facebook_analysis
    user = User.find_by_id(params[:api_id])
    friend = user.friends.where(:fb_id => user.facebook_id).first
    result = Result.where(:user_id => friend.id)
    result.first.analysis
  end




end
