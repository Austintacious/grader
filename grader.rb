require 'csv'

@all_grades = {} 
@averages = []   

def get_input
  puts "What CSV file would you like to load?"
  file = gets.chomp
  if File.exist?(file)
    puts "Loading #{file}..."
    puts "======="
    load_file(file)
    if @all_grades.values.first[:grades].include?(0)
      puts "Wrong number of grades. Check CSV file."
      exit      
    end
    print_letter_average
    update_report
    analyze_course
  elsif file.match(/\w*[^.csv]\z/)
    puts "Wrong extension, please try again."
    get_input
  else
    puts "File not found"
    get_input
  end
end

def load_file(file)
  CSV.foreach(file, headers: true) do |row|
    name = row['first_name'] + " " + row['last_name']
    @all_grades[name] = Hash.new
    @all_grades[name][:grades] = [row['sub1'].to_i,row['sub2'].to_i,row['sub3'].to_i,row['sub4'].to_i,row['sub5'].to_i]
  end
end

def analyze_course
  @avg_array = []
  @all_grades.each do |key, value|
    @avg_array << value[:avg]
  end
  @class_avg = format_number(@avg_array.reduce(:+) / (@all_grades.keys.length).to_f)
  @class_min = format_number(@avg_array.min)
  @class_max = format_number(@avg_array.max)
  @running_avg = []
  @avg_array.each do |avg|
    diff = (avg).to_f - (@class_avg).to_f
    @running_avg << diff ** 2
   end
  @variance = (@running_avg.reduce(:+) / (@all_grades.keys.length).to_f)
  @standard_dev = Math.sqrt(@variance)
  puts "=========="
  puts "Class Average: #{@class_avg}"
  puts "Class Min: #{@class_min}"
  puts "Class Max: #{@class_max}"
  puts "Standard Deviation: #{format_number(@standard_dev)}"
end

def format_number(num)
  sprintf("%.1f",num)
end

def print_average
  @all_grades[name][:grades].each do |key, value|
    print "#{key}: #{(value.reduce(:+) / value.length)}"
  end
end

def print_letter_average
  @all_grades.each do |name, info|
    @all_grades[name][:grades].each do |key, value|
      @all_grades[name][:avg] = (@all_grades[name][:grades].reduce(:+) / @all_grades[name][:grades].length)
      if @all_grades[name][:avg] >= 90
        @all_grades[name][:letter] = "A"
      elsif @all_grades[name][:avg] >= 80 && @all_grades[name][:avg] < 90
        @all_grades[name][:letter] = "B"
      elsif @all_grades[name][:avg] >= 70 && @all_grades[name][:avg] < 80
        @all_grades[name][:letter] = "C"
      elsif @all_grades[name][:avg] >= 60 && @all_grades[name][:avg] < 70
        @all_grades[name][:letter] = "D"
      elsif @all_grades[name][:avg] < 60
        @all_grades[name][:letter] = "F"
      end
    end
  end
    i=0
    while i < @all_grades.keys.length
      @averages << "#{@all_grades.keys[i]}: #{format_number(@all_grades.values[i][:avg])} #{@all_grades.values[i][:letter]}"
      i+=1
    end
    puts @averages
end

def update_report
  File.open("report_card.txt", "w") do |file|
    file.write("#{@averages[0]}
      \n#{@averages[1]}
      \n#{@averages[2]}
      \n#{@averages[3]}
      \n#{@averages[4]}
      \n#{@averages[5]}")
  end
end

get_input