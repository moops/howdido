class LookupsController < ApplicationController
  # GET /lookups
  # GET /lookups.xml
  def index
    @lookups = Lookup.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lookups }
    end
  end

  # GET /lookups/1
  # GET /lookups/1.xml
  def show
    @lookup = Lookup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @lookup }
    end
  end

  # GET /lookups/new
  # GET /lookups/new.xml
  def new
    @lookup = Lookup.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @lookup }
    end
  end

  # GET /lookups/1/edit
  def edit
    @lookup = Lookup.find(params[:id])
  end

  # POST /lookups
  # POST /lookups.xml
  def create
    @lookup = Lookup.new(params[:lookup])

    respond_to do |format|
      if @lookup.save
        format.html { redirect_to(@lookup, :notice => 'Lookup was successfully created.') }
        format.xml  { render :xml => @lookup, :status => :created, :location => @lookup }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lookups/1
  # PUT /lookups/1.xml
  def update
    @lookup = Lookup.find(params[:id])

    respond_to do |format|
      if @lookup.update_attributes(params[:lookup])
        format.html { redirect_to(@lookup, :notice => 'Lookup was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @lookup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lookups/1
  # DELETE /lookups/1.xml
  def destroy
    @lookup = Lookup.find(params[:id])
    @lookup.destroy

    respond_to do |format|
      format.html { redirect_to(lookups_url) }
      format.xml  { head :ok }
    end
  end
end
