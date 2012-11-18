class TellsController < ApplicationController
  # GET /tells
  # GET /tells.json
  def index
    @tells = Tell.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tells }
    end
  end

  # GET /tells/1
  # GET /tells/1.json
  def show
    @tell = Tell.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tell }
    end
  end

  # GET /tells/new
  # GET /tells/new.json
  def new
    @tell = Tell.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tell }
    end
  end

  # GET /tells/1/edit
  def edit
    @tell = Tell.find(params[:id])
  end

  # POST /tells
  # POST /tells.json
  def create
    @tell = Tell.new(params[:tell])

    respond_to do |format|
      if @tell.save
        format.html { redirect_to @tell, notice: 'Tell was successfully created.' }
        format.json { render json: @tell, status: :created, location: @tell }
      else
        format.html { render action: "new" }
        format.json { render json: @tell.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tells/1
  # PUT /tells/1.json
  def update
    @tell = Tell.find(params[:id])

    respond_to do |format|
      if @tell.update_attributes(params[:tell])
        format.html { redirect_to @tell, notice: 'Tell was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @tell.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tells/1
  # DELETE /tells/1.json
  def destroy
    @tell = Tell.find(params[:id])
    @tell.destroy

    respond_to do |format|
      format.html { redirect_to tells_url }
      format.json { head :no_content }
    end
  end
end
