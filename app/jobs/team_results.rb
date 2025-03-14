# This class load the 2 day results file and clculates the team scores.
class TeamResults
  include SuckerPunch::Job
  include ApplicationHelper

  def perform(file)
    p "Updating Team Results Start"
    @max_time = APP_CONFIG[:max_time]
    process_results_file(file[0])
    calculate_awt
  end

  def calculate_awt
    ActiveRecord::Base.transaction do
      delete_awt_results
      classes = SCORE_CLASSES
      classes.each { |c| calculate_awt_by_class(c[1]) }
      update_team_scores
    end
  end

  def update_team_scores
    sortvalue = 9999.0
    teams = Team.all
    teams.each do |team|
      team.update_team_scores
      team.save
    end
  end

  def calculate_awt_by_class(team_class)
    male_entryclass = team_class["male"]
    female_entryclass = team_class["female"]
    #day 1
    day1_awt_m = calculate_awt_by_class_gender(male_entryclass, 1)
    day1_awt_f = calculate_awt_by_class_gender(female_entryclass, 1)
    day1_cat = get_category_time(day1_awt_m, day1_awt_f)
    update_day_awt(day1_awt_m, male_entryclass, 1, day1_cat) if day1_awt_m
    update_day_awt(day1_awt_f, female_entryclass, 1, day1_cat) if day1_awt_f
    #day 2
    day2_awt_m = calculate_awt_by_class_gender(male_entryclass, 2)
    day2_awt_f = calculate_awt_by_class_gender(female_entryclass, 2)
    day2_cat = get_category_time(day2_awt_m, day2_awt_f)
    update_day_awt(day2_awt_m, male_entryclass, 2, day2_cat) if day2_awt_m
    update_day_awt(day2_awt_f, female_entryclass, 2, day2_cat) if day2_awt_f
    update_day_scores(day1_awt_m, day2_awt_m, day1_cat, day2_cat, male_entryclass)
    update_day_scores(day1_awt_f, day2_awt_f, day1_cat, day2_cat, female_entryclass)
  end

  def delete_awt_results
    Day1Awt.delete_all
    Day2Awt.delete_all
  end

  def update_day_awt(awt, entryclass, day, cat_time)
    klass = "Day#{day}Awt".constantize
    float_time = "float_time#{day}".to_sym
    time_day = "time#{day}".to_sym
    runners = awt[:runners]
    first_runner = runners[0]
    second_runner = runners[1]
    third_runner = runners[2]

    klass.create do |awt_row|
      awt_row.entryclass          =  entryclass
      awt_row.runner1_id          =  first_runner[:id]
      awt_row.runner1_float_time  =  first_runner[float_time]
      awt_row.runner1_time        =  first_runner[time_day]
      if second_runner
        awt_row.runner2_id          =  second_runner[:id] || nil
        awt_row.runner2_float_time  =  second_runner[float_time] || nil
        awt_row.runner2_time        =  second_runner[time_day] || nil
      end
      if third_runner
        awt_row.runner3_id          =  third_runner[:id]
        awt_row.runner3_float_time  =  third_runner[float_time]
        awt_row.runner3_time        =  third_runner[time_day]
      end
      awt_row.cat_float_time      =  cat_time
      awt_row.awt_float_time      =  awt[:awt]
    end
  end

  def update_day_scores(awt1, awt2, day1_cat, day2_cat, entryclass)
    runners = Runner.where(entryclass: entryclass)
    runners.each do |runner|
      day1_classifier = runner.classifier1
      day2_classifier = runner.classifier2

      if day1_classifier
        if runner.non_compete1
          runner.day1_score = 0.0
        elsif   ["2", "3", "4", "5"].include? day1_classifier
          if day1_cat > 0
            runner.day1_score = 10 + (60 * (@max_time/day1_cat))
          end
        elsif (day1_classifier === "0" && runner.float_time1 > 0 && awt1)
          runner.day1_score = 60 * (runner.float_time1/awt1[:awt])
        end
      end
      if day2_classifier
        if runner.non_compete2
          runner.day2_score = 0.0
        elsif ["2", "3", "4", "5"].include? day2_classifier
          if day2_cat > 0
            runner.day2_score = 10 + (60 * (@max_time/day2_cat))
          end
        elsif (day2_classifier === "0" && runner.float_time2 > 0 && awt2)
          runner.day2_score = 60 * (runner.float_time2/awt2[:awt])
        end
        if (awt1 || awt2)
          runner.save
        end
      end
    end
  end

  def get_category_time(m_awt, f_awt)
    # for the calculation of DSQ, MSP OVT scores
    # will return the lowest time between male and female 
    # which will give the largest score when used in AWT calculation
    male = 0
    female = 0
    male = m_awt[:awt] if m_awt
    female = f_awt[:awt] if f_awt
    cat_time = male < female  ? male : female
  end

  def calculate_awt_by_class_gender(team_class, day)
    times = []
    awt_runners = Runner.where(entryclass: team_class)
                    .where("classifier#{day} = 0 and float_time#{day} > 0 and non_compete#{day} is false")
                      .order("float_time#{day}").limit(3)
    return nil if awt_runners.count == 0
    awt_runners.each { |r| times.push(r.send("float_time#{day}")) }
    awt = get_awt_time(times)
    {runners: awt_runners, awt: awt}
  end

  def get_awt_time(times)
    times.inject(0.0) { |sum, el| sum + el } / times.size
  end

  def process_results_file(file)
    p "Starting to process results file"
    ActiveRecord::Base.transaction do
      p "results runner import"
      
      File.open(file, "r") { |f| Runner.import(f) }
      p "results file processing"
      CSV.foreach(file, :headers => true, :col_sep=> ',', :skip_blanks=>true, :row_sep=>:auto ) do |row|
        if ( (row['Stno'] != nil) &&
             (row['Stno'].length > 0) )
            Runner.import_results_row(row)
        end
      end
    end
    File.delete(file)
  end

end
