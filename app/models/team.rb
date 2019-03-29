class Team < ActiveRecord::Base

  def self.import(file)
    teams = 0
    members = 0
    current_team = nil
    current_class = nil
    CSV.foreach(file.path, headers: true) do |row|
      if (row['Team']) && (row['Class'].include? "I")
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
    scores = TeamMember.joins(:runner)
      .select("team_members.team_id,runners.id as runner_id,runners.day#{day}_score as day_score")
      .where(team_id: self.id).where("runners.day#{day}_score > ?", 0.0)
      .order("runners.day#{day}_score")
      .limit(3)
    if scores.count === 3
      scores.each do |score|
        day_score += score.day_score if score.day_score
      end
    end
    day_score
  end

  def self.find_or_create(row)
    # Class is stored as Short.
    rowclass = row['Short']
    entryclass = nil
    case rowclass
    when 'ISPM', 'ISPF'
      entryclass = 'ISP'
    when 'ISIM', 'ISIF'
      entryclass = 'ISI'
    when 'ISJVM', 'ISJVF'
      entryclass = 'ISJV'
    when 'ISVM', 'ISVF'
      entryclass = 'ISV'
    when 'ICVM', 'ICVF'
      entryclass = 'ICV'
    when 'ICJVM', 'ICJVF'
      entryclass = 'ICJV'
    end
    if entryclass == nil
      puts "Bad class", row
      return
    end
    
    # JROTC Branch is deduced from heuristics. A bit of a hack
    # until I can figure out how to get the JROTC Branch into
    # the OE2010 file.
    jrotc_branch = nil
    if row['Text3'].include? "JROTC"
      case row['Text1']
      when 'Apollo H.S.', 'Bethel H.S.'
        jrotc_branch = "Air Force"
      when 'Calvert H.S.',
        'Daviess County H.S.',
        'Eldorado NJROTC',
        'Gov Thomas Johnson HS',
        'Henry County H.S.',
        'Loudoun County H.S.',
        'Patuxent H.S.',
        'West Carteret HS'
        jrotc_branch = "Navy"
      else
        puts "Unknown JROTC Branch"
        jrotc_branch = "Unknown"
      end
    end
    
    # Categorize
    category = nil
    school = row['Text1']
    if row['Text3'].include? "Club"
      category = "Club"
      school = nil
    elsif row['Text3'].include? "School"
      category = "School"
    elsif row['Text3'].include? "College"
      category = "College"
    else
      puts "Unknown Category"
    end
    
    created = false
    team = Team.find_or_create_by(name: row['Text2'],
                                  entryclass: entryclass,
                                  JROTC_branch: jrotc_branch,
                                  school: school,
                                  category: category) do |w|
      created = true
    end
    
    return team, created
  end

  def self.assign_member(team, row)
    runner = Runner.where(database_id: row["Database ID"]).first
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
