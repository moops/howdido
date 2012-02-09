class ParticipationsController < ApplicationController

  load_and_authorize_resource
  
  # GET /participations/new.js
  def new
    @participation.user = User.find(params[:user])
    @participation.result = Result.find(params[:result])
    @participation_types = Lookup.list_for('participation_type')
    respond_to do |format|
      format.js # new.js.erb
    end
  end

  # POST /participations
  # POST /participations.js
  # POST /participations.xml
  def create
    
    if (Lookup.code_for('participation_type', 'me').id == @participation.type.id)
      # update the age of the result to the age of the user
      @participation.result.age = @participation.user.age
      @participation.result.save
    end
    
    #result = Result.find(params[:participation][:result_id].to_i)
    #for p in Participation.where(:user_id => params[:participation][:user_id], :participation_type => Lookup.code_for('participation_type', 'me').id).all
    #  if p.result.race.id = result.race.id
        # you can't be 'me' in more than one result
    #    logger.info('you can\'t be \'me\' in more than one result')
    #    return false
    #  end
    #end

    respond_to do |format|
      if @participation.save
        format.js   { logger.info("creating participation with JS") }
        format.html { redirect_to(race_path(@participation.result.race), :notice => 'result has been claimed.') }
        format.xml  { render :xml => @participation, :status => :created, :location => @participation }
      else
        format.js   { logger.info("did not create #{@participation} with JS") }
        format.html { render :action => "new" }
        format.xml  { render :xml => @participation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.xml
  def destroy
    @participation.destroy
    
    respond_to do |format|
      format.html { redirect_to(participations_url) }
      format.xml  { head :ok }
    end
  end
end
