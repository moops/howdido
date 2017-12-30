require "csv" 

class WavaFactor
  
  attr_accessor :age, :gender, :distance, :time
  def initialize(a, g, d, t)
    @age = a
    @gender = g
    @distance = d
    @time = t
  end
end

class BuildWava  
     
  def initialize(filename)
    @race_distances = [14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]
    @filename = filename
    @factors = Array.new
    @factor_lines = CSV.read(filename + '.csv')
    @factor_lines.each do |factor_line|
      build_factors_from_row(factor_line)
    end 
  end  

  def build_factors_from_row(row) 
    age = row.shift
    
    for i in 0..33 do
      gender = i < 17 ? 10 : 11
      factor = WavaFactor.new(age, gender, @race_distances[i],row[i])
      @factors << factor
    end
  end 

  def writeFile
    # example line
    # Wava.create({:age => 12, :gender => 11, :distance => 30, :factor => 25731})  # f100k
    @writer = File.new('wava_seeds.rb','w')
    @factors.each do |f|
      line = "Wava.create({:age => #{f.age}, :gender => #{f.gender}, :distance => #{f.distance}, :factor => #{f.time}})"
      @writer.puts(line)
    end
    @writer.close
  end
      
  w = BuildWava.new("wava_table")  
  w.writeFile # prints without duplicates  

end