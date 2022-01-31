# WIOL Champs Scoring System

this is a fork from the 2019 QOC Junior Nationals scoring system which is a fork of the {GAOC Southeast Interscholastic Scoring System}[https://github.com/OldRugger/seis_2] used for the {2019 QOC Junior Nationals}[http://uschamps.qocweb.org] meet.

Here are the modifications for COC WIOL Championships use:

Mapping of Course to Team:

| Short Course | Long Name | Team |
| --- | --- | --- |
| W1F	| Elementary Female | none |
| W1M	| Elementary Male | none |
| W2F	| Middle School | Middle School |
| W2M	| Middle School Male | Middle School |
| W3F	| JV Rookie Female | JV Rookie |
| W3M	| JV Rookie Male | JV Rookie |
| W4F	| JV HS Female | JV Girls |
| W5M	| JV HS Male | JV Boys |
| W5MIC	| JV IC Male | none |
| W6F	| Varsity HS Female | Varsity Girls |
| W6M	| Varsity HS Male | Varsity Boys |
| W8F	| Varsity IC Female | none |
| W8M	| Varsity IC Male | none |

Check for any competitor in the results, where the "Short" field starts with "W" and import those runners and results

Team is setup in the app config Mapping

This is just a couple mods for QOC's specific meet.
* Use +Stno+ instead of +Database_ID+.
* Teams are created during Runner import (the OE2010 file exported from EventReg).
  * +Team.name+ = +Text2+ column.
  * +Team.entryclass+ = +Short+ column (class on short orienteering course)
  * +Team.JROTC_branch+ = Currently hardcoded list or "Unknown" if +Text3+ contains _JROTC_ and school not in hardcoded list.
  * +Team.school+ = +Text1+ or nil if +Text3+ contains _Club_ to indicate a Club team.
  * +Team.category+ = _Club_, _School_ or _College_ depending on search of +Text3+.
* Runners are assigned to Teams based on together: +Name+, +Class+, +JROTC_Branch+, +School+ and +Category+. If any one of those fields do not match, a new Team is created and the runner assigned to it.
* Importing results
  * The +Runner.import+ is re-ran on the results file. If OE is setup to periodically export results, the scorer can make team / runner changes in OE and not have to worry about reimporting on the computer that is displaying results.
* Layout has been adjusted for display of both Interscholasic and Intercollegiate classes.

## Install
1. Clone the repo
2. Install gems
    gem install -v 1.3.0 bundler (optional: --user-install)
    bundle install
    mkdir results
3. Set up the database
    bundle exec rake db:create
    bundle exec rake db:migrate
4. Run
    bundle exec rails s

## Processing
### Import Runners \ Teams
* From the main page, select "Import Runners / Teams"
* From the Runners page select the Choose File, then select Import_Runners.
### Processing results. 
* Copy the OE results file in the the results directory. 
  * The file will be auto detected and processed.
  * Runners / Teams will be clear / re-imported from the results file.
  * *Caution*, the file will be deleted at the end of processing. 