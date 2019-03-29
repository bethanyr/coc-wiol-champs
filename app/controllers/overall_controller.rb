class OverallController < ApplicationController
  def index
    @isvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISVM' and day1_score > 0 and day2_score > 0 order by total;")
    @isvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISVF' and day1_score > 0 and day2_score > 0 order by total;")
    @isjvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISJVM' and day1_score > 0 and day2_score > 0 order by total;")
    @isjvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISJVF' and day1_score > 0 and day2_score > 0 order by total;")
    @isim = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISIM' and day1_score > 0 and day2_score > 0 order by total;")
    @isif = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISIF' and day1_score > 0 and day2_score > 0 order by total;")
    @ispm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISPM' and day1_score > 0 and day2_score > 0 order by total;")
    @ispf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ISPF' and day1_score > 0 and day2_score > 0 order by total;")
    @icvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ICVM' and day1_score > 0 and day2_score > 0 order by total;")
    @icvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ICVF' and day1_score > 0 and day2_score > 0 order by total;")
    @icjvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ICJVM' and day1_score > 0 and day2_score > 0 order by total;")
    @icjvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (day1_score + day2_score) as total  FROM runners where entryclass = 'ICJVF' and day1_score > 0 and day2_score > 0 order by total;")
  end
end
