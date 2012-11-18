class HomeController < ApplicationController
  # GET /tells
  # GET /tells.json
  def index
    @tells = Tell.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tells }
    end
  end
end
