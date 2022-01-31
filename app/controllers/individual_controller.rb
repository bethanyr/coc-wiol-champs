class IndividualController < ApplicationController
  def index
    # Individual Day 1 and Day 2 results
    @class_list = CLASS_LIST
    @runners =  Runner.select("firstname, surname, entryclass, max(non_compete1, non_compete2) as non_compete, classifier1, school_short, day1_score, day2_score, time1, float_time1, classifier2, float_time2, time2, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total")
                    .where(classifier1:  ["0","2","3","4", "5"]).where(classifier2:  ["0","2","3","4", "5"]).order("entryclass, non_compete, total, classifier1, float_time1")
    
  end

  def day1
    @class_list = CLASS_LIST
    @runners =  Runner.select("firstname, surname, entryclass, non_compete1, classifier1, school_short, day1_score, time1, float_time1")
                    .where(classifier1: ["0","2","3","4", "5"]).order("entryclass, non_compete1,classifier1, float_time1")
  end

  def day2
    @class_list = CLASS_LIST
    @runners =  Runner.select("firstname, surname, entryclass, non_compete2, classifier2, school_short, day2_score, time2, float_time2")
                    .where( classifier2: ["0", "2","3","4", "5"]).order("entryclass, non_compete2,classifier2, float_time2")
  end
end