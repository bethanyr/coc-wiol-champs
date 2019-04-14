class Overall2Controller < ApplicationController
  def index
    @isvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISVM' order by total;")
    @isvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISVF' order by total;")
    @isjvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISJVM' order by total;")
    @isjvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISJVF' order by total;")
    @isim = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISIM' order by total;")
    @isif = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISIF' order by total;")
    @ispm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISPM' order by total;")
    @ispf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISPF' order by total;")
    @icvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ICVM' order by total;")
    @icvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ICVF' order by total;")
    @icjvm = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ICJVM' order by total;")
    @icjvf = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ICJVF' order by total;")
    @isvf_jrotc = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISVF' and jrotc = 'JROTC' order by total;")
    @isvm_jrotc = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISVM' and jrotc = 'JROTC' order by total;")
    @isjvf_jrotc = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISJVF' and jrotc = 'JROTC' order by total;")
    @isjvm_jrotc = Runner.find_by_sql("SELECT firstname, surname, school, day1_score, day2_score, (IFNULL(day1_score, 9999) + IFNULL(day2_score, 9999)) as total  FROM runners where entryclass = 'ISJVM' and jrotc = 'JROTC' order by total;")
  end
end