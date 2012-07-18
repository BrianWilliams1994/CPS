class ApplicationController < ActionController::Base
  protect_from_forgery

  def graphdata
    render "graph"
  end

  def data
    raw_cps_data = File.open("#{Rails.root}/vendor/assets/javascripts/schools.json", 'r').read
    needed_cps_data = JSON.parse(raw_cps_data)["data"]

    safety_score_and_parental_involvement = needed_cps_data.select { |school|
      safetyScore = school[25]
      parentInvolvement = school[27]
      safetyScore != "NDA" and parentInvolvement != "NDA"
    }


    safety_score_and_parental_involvement.map! { |school|
      safetyScore = school[25]
      parentInvolvement = school[27]

      "{safetyScore:#{safetyScore}, parentInvolvement: #{parentInvolvement}, schoolName: '#{school[9]}'}"
    }

    render :json => safety_score_and_parental_involvement
  end

end
