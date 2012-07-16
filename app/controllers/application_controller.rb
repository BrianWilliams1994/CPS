class ApplicationController < ActionController::Base
  protect_from_forgery

  def graphdata
    render "graph"
  end
  
  def fake_data
     #[{x:1, y:2},{schoolName:"Chicago Tech", x:3,y:5}]
  end

  def data
    raw_cps_data = File.open("#{Rails.root}/vendor/assets/javascripts/schools.json", 'r').read
    needed_cps_data = JSON.parse(raw_cps_data)["data"]
  
    safety_score_and_parental_involvement = needed_cps_data.map{|school|
      "{safetyScore:#{school[25]}, parentInvolvement: #{school[27]}}"
  }


  #Extract school name, parental involvement score, safety score
  #Return info through render
  render :json=>safety_score_and_parental_involvement
end

end
