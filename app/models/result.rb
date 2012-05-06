class Result < ActiveRecord::Base

  def analysis
    PositivityTestAPI::AnalysisResult.new(:positive_score => positive_score, :negative_score => negative_score, :total_score => score,
      :stats => stats_json)
  end
end
