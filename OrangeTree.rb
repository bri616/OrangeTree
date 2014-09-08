class OrangeGrove
  attr_accessor :orange_count, :soil_quality

  def initialize(num_of_trees)
    @orange_trees = []
    update_soil_quality
    num_of_trees.times {add_orange_tree}
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

    # Use 1-soil quality as a scaling factor for tree growth
    # and fruit production

    # make the highest value 100 at zero trees and scale it linearly
    # with trees until there are 100 trees, and then it is 0 forever after

    if count_trees_in_grove <= 100
      @soil_quality = 100 - count_trees_in_grove
    elsif count_trees_in_grove > 100
      @soil_quality = 0
    end
  end

  def one_year_passes
    @orange_trees.each {|orange_tree| orange_tree.one_year_passes}
    puts count_all_the_oranges
  end

  def count_all_the_oranges
    @orange_count = 0
    @orange_trees.each do |orange_tree|
      @orange_count = @orange_count + orange_tree.count_the_oranges
    end
  end

  class OrangeTree
    attr_accessor :height, :age, :is_alive, :oranges

    def initialize(height=0, age=0)
      @height = height.to_i
      @age = age.to_i
      @oranges = []
    end

    def one_year_passes
      if count_the_oranges > 0
        oranges_fall_off
      end

      tree_gets_older

      if is_alive
        tree_growth
        orange_production
      end

    end

    def tree_gets_older
      @age += 1
      if @age == 17
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
      puts "This year, the tree grew to a height of #{@height}"
    end

    def tree_dies
      puts "This tree died"
      @is_alive = false
    end

    def orange_production
      if @age > 5 && @age <=10
        rand(15..20).times {oranges_grow}
      elsif @age >10 && @age <= 20
        rand(20..40).times {oranges_grow}
      elsif @age >20
        rand(0..5).times {oranges_grow}
      end
      puts "This year this tree produced #{count_the_oranges} oranges"
    end

    def count_the_oranges
      @oranges.length
    end

    def oranges_grow
      @oranges << Orange.new
    end

    def oranges_fall_off
      puts "Last year's oranges fall off..."
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
        @color = [:orange, :green][rand(2)-1]
      end
    end
  end
end
