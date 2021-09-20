require 'csv'

teams_data = {}
average_data = {}
year = team_name  = ''
# read teams files
CSV.parse(File.read("Team.csv")).map{|i| (teams_data[i[0]] = i[1])}

# take input for filter
puts "Which filter you want to apply. Enter number from below list"
puts "1. Year\n2. Team Name\n3. Year and Team Name\n4. None"
filter_type = gets.chomp.to_i
case filter_type
when 1
  puts "Enter year"
  year = gets.chomp
when 2
  puts "Enter team name"
  team_name = gets.chomp
when 3
  puts "Enter year"
  year = gets.chomp
  puts "Enter team name"
  team_name = gets.chomp
end

# parse batting csv to format data
CSV.foreach('Batting.csv', headers: true) do |row|
  next if year.length != 0 && year != row['yearID']
  next if team_name.length != 0 && team_name.downcase.strip != teams_data[row['teamID']].downcase.strip

  if average_data[row['playerID']].nil?
    average_data[row['playerID']] = {'playerID' => row['playerID'], 'yearID' => row['yearID'], 'TeamName' => '', 'BattingAverage' => 0, 'Count' => 0} 
  end
  average_data[row['playerID']]['TeamName'] = average_data[row['playerID']]['TeamName'].length != 0 ? average_data[row['playerID']]['TeamName'] + ", #{teams_data[row['teamID']]}" : average_data[row['playerID']]['TeamName'] + "#{teams_data[row['teamID']]}"
  average_data[row['playerID']]['BattingAverage'] = average_data[row['playerID']]['BattingAverage'].to_f + (row['H'].to_f/row['AB'].to_f)
  average_data[row['playerID']]['Count'] += 1
end

# output the filtered and parsed data
average_data.values.each_with_index do |data, index|
  puts "playerID | yearId | Team name(s) | Batting Average" if index == 0
  puts "#{data['playerID']} | #{data['yearID']} | #{data['TeamName']} | #{(data['BattingAverage']/data['Count']).round(3)}"
end

