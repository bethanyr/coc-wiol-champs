class Teams2Controller < ApplicationController
  def index
    @ids = params['ids'] || false
    @class_list = CLASS_LIST

    @awt = get_awt_with_runners

    
   @isv_school = Team.where(entryclass: 'ISV').where(category: "School").order(:sort_score, :day1_score, :name)
   @isv_club = Team.where(entryclass: 'ISV').where(category: "Club").order(:sort_score, :day1_score, :name)
   @isv_jrotc = Team.where(entryclass: 'ISV').where.not(JROTC_branch: nil).order(:sort_score, :day1_score, :name)
   
   @isjv_school = Team.where(entryclass: 'ISJV').where(category: "School").order(:sort_score, :day1_score, :name)
   @isjv_club = Team.where(entryclass: 'ISJV').where(category: "Club").order(:sort_score, :day1_score, :name)
   @isjv_jrotc = Team.where(entryclass: 'ISJV').where.not(JROTC_branch: nil).order(:sort_score, :day1_score, :name)
   
   @isi_school = Team.where(entryclass: 'ISI').where(category: "School").order(:sort_score, :day1_score, :name)
   @isi_club = Team.where(entryclass: 'ISI').where(category: "Club").order(:sort_score, :day1_score, :name)
   
   @icv_school = Team.where(entryclass: 'ICV').where(category: "College").order(:sort_score, :day1_score, :name)
   @icv_club = Team.where(entryclass: 'ICV').where(category: "Club").order(:sort_score, :day1_score, :name)
   
   @class_list = CLASS_LIST


    @classes = { 'isv_school'   => @isv_school,
                 'isjv_school'  => @isjv_school,
                 'isi_school'   => @isi_school,
                 'isv_club'   => @isv_club,
                 'isjv_club'  => @isjv_club,
                 'isi_club'   => @isi_club,
                 'icv_school'   => @icv_school,
                 'isv_jrotc' => @isv_jrotc,
                 'isjv_jrotc' => @isjv_jrotc}

    @runners = TeamMember.joins(:runner)
      .select("team_members.team_id, runners.id as runner_id,
              runners.database_id as database_id,
              runners.firstname   as firstname,
              runners.surname     as surname,
              runners.time1       as time1,
              runners.time2       as time2,
              runners.float_time1 as float_time1,
              runners.float_time2 as float_time2,
              runners.classifier1 as classifier1,
              runners.classifier2 as classifier2,
              runners.day1_score  as day1_score,
              runners.day2_score  as day2_score,
              runners.entryclass  as entryclass ")
      .order("team_members.team_id, runners.surname").load

  end
end
