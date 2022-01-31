class Teams2Controller < ApplicationController
  def index
    @ids = params['ids'] || false

    @awt = get_awt_with_runners
    @team_classes = Team.distinct.pluck(:entryclass)
    @team_results = Team.includes(:runners).all.order(:entryclass, :sort_score, :day1_score, :name)
  end

  def day1
    @ids = params['ids'] || false

    @awt = get_awt_with_runners
    @team_classes = Team.distinct.pluck(:entryclass)
    @team_results = Team.includes(:runners).all.order(:entryclass, :sort_score, :day1_score, :name)
  end

  def day2
    @ids = params['ids'] || false

    @awt = get_awt_with_runners
    @team_classes = Team.distinct.pluck(:entryclass)
    @team_results = Team.includes(:runners).all.order(:entryclass, :sort_score, :day2_score, :name)
  end
end
