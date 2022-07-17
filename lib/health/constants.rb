module Health
  module Constants
    SCHEDULE_SYMBOLS = %i(
      mondays tuesdays wednesdays thursdays fridays saturdays sundays
      beginning_of_month end_of_month
    ).freeze

    WEEK_DAYS = { sundays: 0, mondays: 1, tuesdays: 2, wednesdays: 3, thursdays: 4, fridays: 5, saturdays: 6 }.freeze
  end
end