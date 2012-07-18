class ApplicationController < ActionController::Base
  protect_from_forgery

  def graphdata
    render "graph"
  end

  def data

    needed_cps_data = get_data_from_file()

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

  def get_data_from_file
    raw_cps_data = File.open("#{Rails.root}/vendor/assets/javascripts/schools.json", 'r').read
    JSON.parse(raw_cps_data)["data"]
  end

  def get_data_from_website
    HTTParty.get "https://data.cityofchicago.org/api/views/9xs2-f89t/rows.json"
  end

end
