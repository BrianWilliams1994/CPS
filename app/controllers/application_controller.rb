class ApplicationController< ActionController::Base
  protect_from_forgery
  def graphdata
    render "graph"
    end
  end
