class ParticipationsController < ApplicationController

  load_and_authorize_resource
  
  # GET /participations/new.js
  def new
    @participation.user = User.find(params[:user])
    @participation.result = Result.find(params[:result])
    @participation_types = Lookup.list_for('participation_type')
  end

  # POST /participations.js
  def create
    @participation = Participation.find_or_build(params[:user], params[:result], params[:type])
    @participation.update_result_age_if_me

    if @participation.save
      logger.info("creating participation with JS")
    else
      logger.info("did not create #{@participation} with JS")
    end
  end

  # DELETE /participations/1
  # DELETE /participations/1.js
  def destroy
    @participation.destroy
    respond_to do |format|
      format.js   { logger.info("destroying participation with JS") }
      format.html { redirect_to participations_path }
    end
  end
end
