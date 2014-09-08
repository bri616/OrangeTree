class OrangeTree
  attr_accessor :height, :age, :is_alive, :oranges

  def initialize(height=0, age=0, is_alive=true)
    @height = height.to_i
    @age = age.to_i
    @is_alive = true
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
    puts "Your tree got really old and died"
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
      @oranges.pop
      puts "Yum, that was a delicious orange"
    end
  end

  class Orange
    attr_accessor :color
    def initialize
      @color = [:orange, :green][rand(2)-1]
    end
  end

end
