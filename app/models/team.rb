class Team < ActiveRecord::Base
  has_many :team_members
  has_many :runners, through: :team_members

  def self.import(file)
    teams = 0
    members = 0
    current_team = nil
    current_class = nil
    CSV.foreach(file.path, headers: true) do |row|
      if (row['Team']) && (row['Class'].include? "W")
        if (current_team == nil || current_team.name != row['Team']) ||
           current_class == nil || !(row['Class'].include? current_class)
          current_team = self.create_team(row)
          current_class = current_team.entryclass
          teams += 1
        end
        self.assign_member(current_team, row)
        members += 1
      end
    end
    [teams, members]
  end

  def update_team_scores
    sortvalue = 9999.0
    day1_score = get_team_day_scores(1)
    day2_score = get_team_day_scores(2)
    self.total_score = day1_score + day2_score
    self.day1_score  = day1_score > 0.0 ? day1_score : sortvalue
    self.day2_score  = day2_score > 0.0 ? day2_score : sortvalue
    self.sort_score  = self.day1_score + self.day2_score
  end

  private

  def get_team_day_scores(day)    
    day_score = 0.0
    scores = self.runners
              .where("day#{day}_score > ?", 0.0)
              .order("runners.day#{day}_score")
              .limit(3)

    if scores.size === 3
      scores.each do |score|
        day_score += score["day#{day}_score"] if score["day#{day}_score"]
      end
    end
    day_score
  end

  def self.find_or_create(row, team_category = '')
    # Class is stored as Short.
    rowclass = row['Short']
    entryclass =team_category
    
    # Categorize
    school = row['Region'] || ''
    name = "#{school} #{team_category}"
    
    created = false
    team = Team.find_or_create_by(name: name,
                                  entryclass: entryclass,
                                  school: school,
                                  category: "School") do |w|
      created = true
    end
    
    return team, created
  end

  def self.assign_member(team, row)
    runner = Runner.where(database_id: row["Stno"]).first
    if runner
      assign_runner_to_team(team, runner, row)
    else
      raise "error: Runner with database_id #{row["Stno"]} not found"
    end

  end
  # match name, school and entry class and no other assignment.
  def self.assign_runner_to_team(team, runner, row)
    raise "error: runner already assigned to a team " if TeamMember.where(runner_id: runner.id).first
    raise "error: invalid entry class #{row}" unless runner.entryclass.include? team.entryclass
    raise "error: runner first name does not match #{row}" unless runner.firstname = row['First']
    raise "error: runner last name does not match #{row}" unless runner.surname = row['Last']
    TeamMember.create(team_id: team.id,
                      runner_id: runner.id)
    #
  end

end
