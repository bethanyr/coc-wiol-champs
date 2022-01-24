class Teams2Controller < ApplicationController
  def index
    @ids = params['ids'] || false

    @awt = get_awt_with_runners
    @team_classes = Team.distinct.pluck(:entryclass)
    @team_results = Team.includes(:runners).all.order(:entryclass, :sort_score, :day1_score, :name)
  end
end
