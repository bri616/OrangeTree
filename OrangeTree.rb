class OrangeGrove
  attr_accessor :orange_count, :soil_quality, :soil_art, :orange_trees

  def initialize(num_of_trees)
    @orange_trees = []
    update_soil_quality
    num_of_trees.times {add_orange_tree}
    production_factor
    show_current_grove(soil_art)
    #ask_to_advance_time
  end

  def show_current_grove(soil_art)
    orange_tree_symbols = @orange_trees.collect {|orange_tree| orange_tree.tree_art}
    orange_totals = @orange_trees.collect {|orange_tree| orange_tree.count_the_oranges}
    nstart = 0
    puts "-" * (12*3+11*3)
    while nstart < orange_tree_symbols.length
      puts " " + orange_totals[nstart...nstart+12].join(" "*5) + " "
      puts orange_tree_symbols[nstart...nstart+12].join(soil_art*3)
      puts "-" * (12*3+11*3)
      nstart += 12
    end
    count_all_the_oranges
    puts "The current orange total this season is #{@orange_count}"
  end

  def add_orange_tree
    orange_tree = OrangeTree.new()
    # Based on the soil quality, each new tree has a chance of dying when added
    if rand(0..300) < (100-@soil_quality)
      orange_tree.tree_dies
    else
      orange_tree.is_alive = true
    end
    @orange_trees << orange_tree
    update_soil_quality
  end

  def count_trees_in_grove
    @orange_trees.length
  end

  def update_soil_quality
    # Soil quality is highest when the number of trees is 0
    # and decreases with increasing number of trees
    # a lower value means trees live longer, produce more fruit
    # Depending on the soil quality, any new tree in the grove has
    # a chance of being dead

    # make the highest value 100 at zero trees and scale it linearly
    # with trees until there are 100 trees, and then it is 0 forever after

    if count_trees_in_grove <= 100
      @soil_quality = 100 - count_trees_in_grove
    elsif count_trees_in_grove > 100
      @soil_quality = 0
    end
  end

  def one_year_passes
    @orange_trees.each {|orange_tree| orange_tree.one_year_passes(production_factor, age_limit)}
    show_current_grove(soil_art)
  end

  def production_factor
    if @soil_quality < 25
      @soil_art = ","
      3
    elsif @soil_quality >= 25 && @soil_quality <=75
      @soil_art = "."
      2
    elsif @soil_quality >75
      @soil_art = "_"
      1
    end
  end

  def age_limit
    if @soil_quality < 25
      68
    elsif @soil_quality >= 25 && @soil_quality <=75
      52
    elsif @soil_quality >75
      27
    end
  end

  def count_all_the_oranges
    @orange_count = 0
    @orange_trees.each do |orange_tree|
      @orange_count = @orange_count + orange_tree.count_the_oranges
    end
  end

  class OrangeTree
    attr_accessor :height, :age, :is_alive, :oranges, :tree_art

    def initialize(height=0, age=0)
      @height = height.to_i
      @age = age.to_i
      @oranges = []
      @tree_art = "_l_"
    end

    def update_tree_art(age_limit)
      if @is_alive == false
        @tree_art="_!_"
      elsif @age == 0 || @age == 1 || @age == age_limit-1
        @tree_art="_l_"
      else
        @tree_art="<|>"
      end
    end

    def self.plant_on(grove)
      grove.add_orange_tree
      # this is how I tested this, with the weirdass :: thing
      # a la namespace sorts of things
      # OrangeGrove::OrangeTree.plant_on(my_grove)
    end


    def one_year_passes(production_factor=1, age_limit=17)
      if count_the_oranges > 0
        oranges_fall_off
      end

      tree_gets_older(age_limit)

      if is_alive
        tree_growth
        orange_production(production_factor)
      end

      update_tree_art(age_limit)

    end

    def tree_gets_older(age_limit)
      @age += 1
      if @age == age_limit
        tree_dies
      end
    end

    def tree_growth
      if @age%5 == 0
        tree_grows
      end
    end

    def tree_grows
      @height += 1
      # puts "This year, the tree grew to a height of #{@height}"
    end

    def tree_dies
      # puts "This tree died"
      @is_alive = false
      @tree_art = "_!_"
    end

    def orange_production(production_factor)
      if @age > 5 && @age <=10
        (rand(15..20)*production_factor).times {oranges_grow}
      elsif @age >10 && @age <= 20
        (rand(20..40)*production_factor).times {oranges_grow}
      elsif @age >20
        (rand(0..5)*production_factor).times {oranges_grow}
      end
      # puts "This year this tree produced #{count_the_oranges} oranges"
    end

    def count_the_oranges
      @oranges.length
    end

    def oranges_grow
      @oranges << Orange.new
    end

    def oranges_fall_off
      # puts "Last year's oranges fall off..."
      @oranges = []
    end

    def pick_an_orange
      if count_the_oranges == 0
        puts "No oranges left to pick this year!"
      else
        theorange = @oranges.pop
        if theorange.color == :orange
          puts "Yum, that was a delicious orange"
        elsif theorange.color == :green
          puts "Yuck, that was a green orange, not yummy"
        end
      end
    end

    class Orange
      attr_accessor :color
      def initialize
        @color = [:orange, :green][rand(0..1)]
      end
    end
  end
end

###################################
# Some code here to make it go
###################################

my_grove = OrangeGrove.new(12)

while true
  puts "Type 'a' to add a tree or '+' to advance a year: (or 'q' to quit)"
  input = gets.chomp
  case input.downcase
  when 'a'
    my_grove.add_orange_tree
  when '+'
    my_grove.one_year_passes
  when 'q'
    break
  end
end
