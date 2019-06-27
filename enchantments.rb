#!/usr/bin/ruby

require 'set'

$max_level = {
  prot: 4,
  fireprot: 4,
  feather: 4,
  blastprot: 4,
  projprot: 4,
  resp: 3,
  aqua: 1,
  thorns: 3,
  depth: 3,
  frost: 2,
  binding: 1,
  sharpness: 5,
  smite: 5,
  bane: 5,
  knock: 2,
  fireasp: 2,
  looting: 3,
  sweep: 3,
  eff: 5,
  silk: 1,
  unb: 3,
  fortune: 3,
  power: 5,
  punch: 2,
  flame: 1,
  infinity: 1,
  luck: 3,
  lure: 3,
  mend: 1,
  vanishing: 1
}

$multiplier_item = {
  prot: 1,
  fireprot: 2,
  feather: 2,
  blastprot: 4,
  projprot: 2,
  resp: 4,
  aqua: 4,
  thorns: 8,
  depth: 4,
  frost: 4,
  binding: 8,
  sharpness: 1,
  smite: 2,
  bane: 2,
  knock: 2,
  fireasp: 4,
  looting: 4,
  sweep: 4,
  eff: 1,
  silk: 8,
  unb: 2,
  fortune: 4,
  power: 1,
  punch: 4,
  flame: 4,
  infinity: 8,
  luck: 4,
  lure: 4,
  mend: 4,
  vanishing: 8
}

$multiplier_book = {
  prot: 1,
  fireprot: 1,
  feather: 1,
  blastprot: 2,
  projprot: 1,
  resp: 2,
  aqua: 2,
  thorns: 4,
  depth: 2,
  frost: 2,
  binding: 4,
  sharpness: 1,
  smite: 1,
  bane: 1,
  knock: 1,
  fireasp: 2,
  looting: 2,
  sweep: 2,
  eff: 1,
  silk: 4,
  unb: 1,
  fortune: 2,
  power: 1,
  punch: 2,
  flame: 2,
  infinity: 4,
  luck: 2,
  lure: 2,
  mend: 2,
  vanishing: 4
}

$prior_work_penalty = [0, 1, 3, 7, 15, 31, 63]

$incompatible_enchantments = Set.new

def add_incompatible_enchantment(arr)
  arr.each do |i|
    arr.each do |j|
      next if i==j
      $incompatible_enchantments << [i, j]
      $incompatible_enchantments << [j, i]
    end
  end
end

# add_incompatible_enchantment([:prot, :fireprot, :blastprot, :projprot])
add_incompatible_enchantment([:depth, :frost])
add_incompatible_enchantment([:sharpness, :bane, :smite])
add_incompatible_enchantment([:silk, :fortune])

def are_incompatible(a, b)
  return $incompatible_enchantments.include?([a, b])
end


$tool_enchantments = {}

def add_tool_enchantments(ench, toolarr)
  toolarr.each do |tool|
    $tool_enchantments[tool] = Set.new if (!$tool_enchantments.has_key?(tool))
    $tool_enchantments[tool] << ench
  end
end

add_tool_enchantments(:prot, [:helmet, :chestplate, :leggings, :boots])
add_tool_enchantments(:fireprot, [:helmet, :chestplate, :leggings, :boots])
add_tool_enchantments(:blastprot, [:helmet, :chestplate, :leggings, :boots])
add_tool_enchantments(:projprot, [:helmet, :chestplate, :leggings, :boots])
add_tool_enchantments(:thorns, [:helmet, :chestplate, :leggings, :boots])
add_tool_enchantments(:feather, [:boots])
add_tool_enchantments(:depth, [:boots])
add_tool_enchantments(:frost, [:boots])
add_tool_enchantments(:resp, [:helmet])
add_tool_enchantments(:aqua, [:helmet])
add_tool_enchantments(:binding, [:helmet, :chestplate, :leggings, :boots, :elytra, :pumpkin, :head])
add_tool_enchantments(:sharpness, [:sword, :axe])
add_tool_enchantments(:smite, [:sword, :axe])
add_tool_enchantments(:bane, [:sword, :axe])
add_tool_enchantments(:knock, [:sword])
add_tool_enchantments(:fireasp, [:sword])
add_tool_enchantments(:looting, [:sword])
add_tool_enchantments(:sweep, [:sword])
add_tool_enchantments(:eff, [:pick, :shovel, :axe, :shears])
add_tool_enchantments(:silk, [:pick, :shovel, :axe])
add_tool_enchantments(:unb, [:pick, :shovel, :axe, :rod, :helmet, :chestplate, :leggings, :boots, :sword, :bow, :hoe,
                      :shears, :flintsteel, :carrotstick, :shield, :elytra])
add_tool_enchantments(:fortune, [:pick, :shovel, :axe])
add_tool_enchantments(:power, [:bow])
add_tool_enchantments(:punch, [:bow])
add_tool_enchantments(:flame, [:bow])
add_tool_enchantments(:infinity, [:bow])
add_tool_enchantments(:luck, [:rod])
add_tool_enchantments(:lure, [:rod])
add_tool_enchantments(:mend, [:pick, :shovel, :axe, :rod, :helmet, :chestplate, :leggings, :boots, :sword, :bow, :hoe,
                      :shears, :flintsteel, :carrotstick, :shield, :elytra])
add_tool_enchantments(:vanishing, [:pick, :shovel, :axe, :rod, :helmet, :chestplate, :leggings, :boots, :sword, :bow, :hoe,
                      :shears, :flintsteel, :carrotstick, :shield, :elytra, :pumpkin, :head])


class Item
  attr_accessor :item, :enchantments, :rework, :damaged
  
  def <=>(x)
    i = @enchantments.size <=> x.enchantments.size
    return i if (i && i != 0)
    i = @enchantments <=> x.enchantments
    return i if (i && i != 0)
    i = @item <=> x.item
    return i if (i && i != 0)
    i = @rework <=> x.rework
    return i if (i && i != 0)
    return @damaged <=> x.damaged
  end
  
  def dump
    "Item:#{@item} Rework:#{@rework} Damage:#{@damaged} Ench:#{@enchantments.inspect}"
  end
  
  def construct(other)
    x = Item.new(false, nil, nil, 0, 0)
    
    if @item==other.item
      x.item = @item
    elsif @item==:book
      x.item = other.item
    elsif other.item==:book
      x.item = @item
    end
      
    x.enchantments = @enchantments.merge(other.enchantments)
    x.rework = @rework + other.rework
    x.damaged = @damaged || other.damaged
    x
  end
    
  def combine(sacrifice)
    x = Item.new(false, nil, 0, 0)
    
    if @item==sacrifice.item
      x.item = @item
    elsif @item==:book
      x.item = sacrifice.item
    elsif sacrifice.item==:book
      x.item = @item
    end
    
    x.enchantments = {}
    $multiplier_book.each_key do |key|
      next if (x.item != :book && !$tool_enchantments[x.item].include?(key))
      
      combo = nil
      mine = @enchantments[key]
      his = sacrifice.enchantments[key];
      if (mine.nil?)
        combo = his
      elsif (his.nil?)
        combo = mine
      else
        if (his>mine)
          combo = his
        elsif (mine>his)
          combo = mine
        else
          combo = mine+1
        end
      end
      
      if (combo)
        combo = $max_level[key] if (combo>$max_level[key])
        x.enchantments[key] = combo
      end
    end
    
    x.rework = @rework
    x.rework = sacrifice.rework if (sacrifice.rework > @rework)
    x.rework += 1
    x.damaged = false
    x
  end

  def combine_cost(sacrifice)
    # puts @rework
    # puts sacrifice.rework
    return 1000 if (@rework>=5) || (sacrifice.rework>=5) 
    cost = $prior_work_penalty[@rework] + $prior_work_penalty[sacrifice.rework]
    cost += 2 if (@damaged)
    # return nil if cost>39
    return cost if cost>39
    
    mul_table_target = nil
    mul_table_sacrifice = nil
    item = nil
    if @item==:book && sacrifice.item==:book
      mul_table_target = $multiplier_book
      mul_table_sacrifice = $multiplier_book
      item = :book
    elsif @item==:book
      return 1000
    elsif sacrifice.item==:book
      mul_table_target = $multiplier_item
      mul_table_sacrifice = $multiplier_book
      item = @item
    elsif (sacrifice.item != @item)
      return 1000
    else
      mul_table_target = $multiplier_item
      mul_table_sacrifice = $multiplier_item
      item = @item
    end
    
    enchantments = {}
    @enchantments.each do |k,v|
      enchantments[k] = v
    end
    
    $multiplier_book.each_key do |key|
      next if !enchantments.has_key?(key) && !sacrifice.enchantments.has_key?(key)
      
      if (@item != :book)
        if sacrifice.enchantments.has_key?(key)
          if (!$tool_enchantments[item].include?(key))
            cost += 1
            next
          end
        end
      end
      
      if sacrifice.enchantments.has_key?(key)
        incompat = false        
        enchantments.each_key do |key2|
          if (are_incompatible(key, key2))
            cost += 1
            incompat = true
            break
          end
        end
        next if incompat
        
        his = sacrifice.enchantments[key];
        if (enchantments.has_key?(key))
          combo = nil
          mine = enchantments[key]
          if (his>mine)
            combo = his
            cost += mul_table_sacrifice[key] * combo
          elsif (mine>his)
            combo = mine
            cost += mul_table_target[key] * combo
          else
            combo = mine+1
            combo = $max_level[key] if (combo>$max_level[key])
            cost += mul_table_target[key] * combo
          end
      
          enchantments[key] = combo
        else
          enchantments[key] = his
          cost += mul_table_sacrifice[key] * his
        end
      end
    end
    
    # return nil if cost>39
    cost
  end
    
  def initialize(item, ench, rework=0, damaged=false)
    @item = item
    # @enchantments = {}
    # @enchantments = {type => level} if (type && level)
    @enchantments = ench
    @rework = rework
    @damaged = damaged
  end
end

$memo = {}
$memo2 = {}

def find_lowest_cost(item_list, level=0)
  # item_list.sort!
  # ret = $memo2[item_list]
  # if (!ret.nil?)
  #   puts "found"
  #   return ret
  # end
  
  best_cost = 10000
  best_i = -1
  best_j = -1
  best_ret = []
  
  item_list.each_index do |j|
    itemj = item_list[j]
    item_list.each_index do |i|
      next if i==j
      itemi = item_list[i]
      # next if (itemj.rework - itemi.rework).abs > 1
      
      mx = [itemj, itemi]
      cost = $memo[mx]
      if (cost.nil?)
        cost = itemj.combine_cost(itemi)
        $memo[mx] = cost
      end
      next if cost > 30
      combo = itemj.combine(itemi)
      pair = [cost, itemj, itemi, combo]      
      
      # puts "TRY"
      # puts "Level    #{level}"
      # puts "Combine: #{pair[1].dump}"
      # puts "   With: #{pair[2].dump}"
      # puts "   Cost: #{pair[0]}"
      # puts "  Makes: #{pair[3].dump}"
      # puts
      
      if (item_list.size>2)
        new_list = []
        item_list.each_index do |k|
          next if (k == i || k == j)
          new_list << item_list[k]
        end
        new_list << combo
      
        ret = find_lowest_cost(new_list, level+1)
        next if ret.size==0
        cost += ret[0][0]
        ret = [pair] + ret
      else
        ret = [pair]
      end
            
      if (cost < best_cost)
        best_cost = cost
        best_ret = ret
        
        # printf(" c=%2d l=%d   \r", best_cost, level)
        # $stdout.flush
        puts "BEST"
        puts "Level    #{level}"
        puts "Combine: #{pair[1].dump}"
        puts "   With: #{pair[2].dump}"
        puts "   Cost: #{pair[0]}"
        puts "  Makes: #{pair[3].dump}"
        puts
        return ret
        
      end
    end
  end
  
  # $memo2[item_list] = best_ret
  best_ret
end

def find_lowest_costx(item_list)
  while (item_list.size()>1)
    item_list.each_index do |j|
      item_list.each_index do |i|
        next if i==j
        cost = item_list[j].combine_cost(item_list[i])
        next if (cost.nil?)
        if (cost < best_cost)
          best_cost = cost
          best_i = i
          best_j = j
        end
      end
    end
    
    combo = item_list[best_j].combine(item_list[best_i])
    
    puts "Combine: #{item_list[best_j].dump}"
    puts "   With: #{item_list[best_i].dump}"
    puts "   Cost: #{best_cost}"
    
    if (best_j > best_i)
      item_list.delete_at(best_j)
      item_list.delete_at(best_i)
    else
      item_list.delete_at(best_i)
      item_list.delete_at(best_j)
    end
    puts "  Makes: #{combo.dump}"
    puts
    item_list << combo
  end
end

        
      

# thorns = Item.new(:book, :thorns, 2)
# thorns = thorns.combine(thorns)
# leggings = Item.new(:leggings, :prot, 3)
# unb3 = Item.new(:book, :unb, 3)
# prot4 = Item.new(:book, :prot, 4)
# mend = Item.new(:book, :mend, 1)
# item_list = [thorns, leggings, unb3, prot4, mend]

# chest = Item.new(:chestplate, :unb, 3).construct(Item.new(:chestplate, :prot, 3))
# thorns = Item.new(:book, :thorns, 2)
# thorns = thorns.combine(thorns)
# protkb = Item.new(:book, :prot, 3).combine(Item.new(:book, :knock, 3))
# mend = Item.new(:book, :mend, 1)
# item_list = [thorns, chest, protkb, mend]

# boots = Item.new(:boots, :unb, 3)
# protlure = Item.new(:book, :prot, 4).combine(Item.new(:book, :lure, 2))
# mend = Item.new(:book, :mend, 1)


## Separate enchantments for helmet
# thorns = Item.new(:book, :thorns, 2)
# thorns = thorns.combine(thorns)
# mend = Item.new(:book, :mend, 1)
# prot4 = Item.new(:book, :prot, 4)
# fireprot4 = Item.new(:book, :fireprot, 4)
# projprot4 = Item.new(:book, :projprot, 4)
# blastprot4 = Item.new(:book, :blastprot, 4)
# aqua = Item.new(:book, :aqua, 4)
# unb3 = Item.new(:book, :unb, 3)
# resp3 = Item.new(:book, :resp, 3)
# helmet = Item.new(:helmet, nil, 0)
# item_list = [thorns, helmet, fireprot4, projprot4, blastprot4, aqua, unb3, mend, prot4, resp3]
# # item_list = [mend, unb3, aqua, resp3, helmet, fireprot4, projprot4, blastprot4, prot4]

## Helmet
item_list = []
# item_list << Item.new(:book, {:thorns => 2})
# item_list << Item.new(:book, {:thorns => 2})
# item_list << Item.new(:book, {:blastprot => 4})
# item_list << Item.new(:book, {:projprot => 4, :prot => 3, :aqua => 1})
# item_list << Item.new(:book, {:resp => 3, :prot => 3})
# item_list << Item.new(:book, {:mend => 1, :unb => 3, :knockback => 1, :smite => 1})
# item_list << Item.new(:book, {:fireprot => 3})
# item_list << Item.new(:book, {:fireprot => 3, :power => 3})
# item_list << Item.new(:helmet, {})


item_list = []
item_list << Item.new(:book, {:thorns => 2})
item_list << Item.new(:book, {:thorns => 2})
item_list << Item.new(:book, {:mend => 1})
item_list << Item.new(:book, {:prot => 3})
item_list << Item.new(:book, {:unb => 3, :fireprot => 3, :prot => 3})
item_list << Item.new(:book, {:fireprot => 3, :feather => 4})
item_list << Item.new(:book, {:blastprot => 4})
item_list << Item.new(:book, {:depth => 3, :projprot => 4})
item_list << Item.new(:helmet, {})


ret = find_lowest_cost(item_list)

puts "DECISION"
ret.each do |pair|
  puts "Combine: #{pair[1].dump}"
  puts "   With: #{pair[2].dump}"
  puts "   Cost: #{pair[0]}"
  puts "  Makes: #{pair[3].dump}"
  puts
end
