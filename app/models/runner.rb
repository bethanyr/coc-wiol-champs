class Runner < ActiveRecord::Base
  has_many :teams, through: :team_members
  has_many :team_members

  scope :day1_competitive, -> { where(non_compete1: 0).where(classifier1: ["0", "2","3","4", "5"]) }
  scope :day2_competitive, -> { where(non_compete2: 0).where(classifier2: ["0", "2","3","4", "5"]) }

  def self.import(file)
    added = 0
    teams = 0
    skipped = 0
    self.clear_existing_data
    p "Starting runner import"
    CSV.foreach(file.path, headers: true) do |row|
      if row["OE0002"] == "***"
        skipped += 1
      elsif row["Short"].length > 0
        if row["Region"]
          school = row["Region"]
          school_short = row["City"]
        else
          school = "N_A"
          school_short = "N_A"
        end

        entryclass = row["Short"]
        runner = Runner.create(database_id: row["Stno"],
                      surname: row["Surname"].gsub("'"){"\\'"},
                      firstname: row["First name"].gsub("'"){"\\'"},
                      school: school.gsub("'"){"\\'"},
                      school_short: school_short,
                      entryclass: entryclass,
                      gender: row["S"])
        added += 1
        
        # Runner is created, now check their team information. Attempt
        # to find team and then create it if necessary.
        # Region = School Name
        # Text2 = Team Name
        # Text3 = Team Type
        team = nil
        if entryclass
          team_category = APP_CONFIG[:team_mapping][entryclass]     
          if team_category
            # Find Team
            team, created = Team.find_or_create(row, team_category)
            if team == nil
              puts "Something bad happened. Team wasn't created."
            end
            
            if created
              teams += 1
            end
            
            TeamMember.create(team_id: team.id,
                              runner_id: runner.id)
          end
        end
      end
    end
    [added, skipped]
  end

  def self.import_results_row(row)
    if (row["Time1"])
      res = self.get_float_time(row["Time1"])
      float_time1 = res['float']
      time1 =  res['time']
    else
      float_time1 = 0.0
    end
    if (row["nc2"])
      nc2 = row["nc2"].gsub("X"){"1"}
    else
      nc2 = "0"
    end
    if (row["Time2"])
      res = self.get_float_time(row["Time2"])
      float_time2 = res['float']
      time2 =  res['time']
    else
      float_time2 = 0.0
    end
    if (row["Total"])
      res = self.get_float_time(row["Total"])
      float_total = res['float']
      total =  res['time']
    else
      float_total = 0.0
    end
    Runner.where(database_id: row['Stno'].to_s)
      .update_all(time1: time1,
                  float_time1: float_time1,
                  classifier1: row["Classifier1"].to_s,
                  non_compete1: row["nc1"].gsub("X"){"1"},
                  time2: time2,
                  float_time2: float_time2,
                  classifier2: row["Classifier2"].to_s,
                  non_compete2: nc2,
                  total_time: total,
                  float_total_time: float_total)

  end

  private

  def self.clear_existing_data
    TeamMember.delete_all
    Team.delete_all
    Day1Awt.delete_all
    Day2Awt.delete_all
    Runner.delete_all
  end

  def self.get_float_time(time)
    float_time = 0.0
    hhmmss = time.split(":")
    if (hhmmss.length ==3 ) then
      time = time
      hh = hhmmss[0].to_i
      mm = hhmmss[1].to_i
      ss = hhmmss[2].to_i
      float_Time = (hh*60) + mm + (ss/60.0)
    elsif (hhmmss.length == 2) then
      time = "00:" + time
      mm = hhmmss[0].to_i
      ss = hhmmss[1].to_i
      float_Time = mm + (ss/60.0)
    end
    {'float' => float_Time, 'time' => time}
  end

end
