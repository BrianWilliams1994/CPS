class ApplicationController < ActionController::Base
  protect_from_forgery

  def graphdata
    render "graph"
  end

  def data
    raw_cps_data = JSON.parse(get_data_from_website)["data"]

    safety_score_and_parental_involvement = raw_cps_data.select { |school|
      safetyScore = school[25]
      parentInvolvement = school[27]
      are_safety_score_and_parent_involvement_numbers_valid? safetyScore, parentInvolvement
    }

    safety_score_and_parental_involvement.map! { |school|
      safetyScore = school[25]
      parentInvolvement = school[27]
      schoolName = school[9]

      {"safetyScore" => safetyScore.to_i, "parentInvolvement" => parentInvolvement.to_i, "schoolName" => schoolName}.to_json
    }

    render :json => safety_score_and_parental_involvement
  end

  def are_safety_score_and_parent_involvement_numbers_valid? safetyScore, parentInvolvement
    safetyScore != "NDA" and parentInvolvement != "NDA" and safetyScore != nil and parentInvolvement != nil
  end

  def get_data_from_file
    File.open("#{Rails.root}/vendor/assets/javascripts/schools.json", 'r').read
  end

  def get_data_from_website
    HTTParty.get("https://data.cityofchicago.org/api/views/9xs2-f89t/rows.json").body
  end

end
