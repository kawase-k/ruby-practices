require "date"
require "optparse"
params = ARGV.getopts("y:", "m:")

today = Date.today
year  = today.year
month = today.month
week  = %w(日 月 火 水 木 金 土)

#-yの引数を取得
y_year = params["y"].to_i
if y_year == 0
  y_year = year
end

#-mの引数を取得
m_month = params["m"].to_i
if m_month == 0
  m_month = month
end

#日付を取得
date_first = Date.new(y_year, m_month, 1).day
date_last  = Date.new(y_year, m_month, -1).day

#曜日を取得
week_first = Date.new(y_year, m_month, 1).wday

puts "#{m_month}月 #{y_year}".center(20)
puts week.join(" ")
print "   " * week_first 

(date_first..date_last).each do |x|
  print x.to_s.rjust(2) + " " 
  week_first += 1
  if week_first % 7 == 0 
    print "\n"
  end
end

puts "\n"
