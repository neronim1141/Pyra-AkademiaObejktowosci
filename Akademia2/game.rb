#create map

map_size = 5 # x*x
world = Array.new(map_size){Array.new(map_size," ")}
#inputKeys
keys={
    "w"=>:up,
    "s"=>:down,
    "a"=>:left,
    "d"=>:right,
    "r"=>:rest,
    "q"=>:quit
}
def Instruction(keys)# write instructions
  keys.each do |key,description|
    print key,"-",description
    if keys.keys.last != key
      print ", "
    end

  end
  puts
end
#create entities
entities ={
    "Player"=>{
        "Texture"=>"P",
        "x"=>0,
        "y"=>0,
        "max_hp"=>10,
        "hp"=>10,
        "Points"=>0
    }
}
Random.new_seed
def Add_monster(entities,map_size)
  x=rand(map_size)
  y=rand(map_size)

 while x == entities["Player"]["x"] do
    x=rand(map_size)
 end
  while y== entities["Player"]["y"] do
    y=rand(map_size)
  end
 entities["Monster"]= {
     "Texture"=>"M",
     "x"=>x,
     "y"=>y,
     "Points"=>2
 }

end


def Draw_hp(hp) #draw hp of entity
  hp.times do
    print "▌ "
  end
  puts
end
def Write_hp(hp)
  puts "HP: "+hp.to_s
end

def onCollision(obj1,obj2)#check collision
  if(obj1["x"]==obj2["x"] and obj1["y"]==obj2["y"])
    return true
  else
    return false
  end
end

#screen render
def Put_entities(world,entities) #add entities to world
  entities.each do |_,entity|
    world[entity["y"]][entity["x"]] = entity["Texture"]
  end
end
def Render_world(world)#draw world
  world.each  do |x|
    x.each  do |y|
       print  y
    end
    puts
  end
end
def Restore_world(world,entities)#restore world to initial
  entities.each do |_,entity|
    world[entity["y"]][entity["x"]] = " "
  end
end

def Render(world,entities,keys) #render screen

  puts "punkty: " + entities["Player"]["Points"].to_s
  Put_entities(world,entities)
  Render_world(world)
  Restore_world(world,entities)
  Draw_hp(entities["Player"]["hp"])
  Instruction(keys)
end


Add_monster(entities,map_size) #add first monster
while(true)#execute endlessly unless player dont quit
  Render(world,entities,keys)
  action = gets.chomp#wait for char
  case keys[action.downcase]
    when :up
      entities["Player"]["y"] -= entities["Player"]["y"] == 0 ? 0 : 1
    when :down
      entities["Player"]["y"] += entities["Player"]["y"] == map_size-1 ? 0 : 1
    when :left
      entities["Player"]["x"] -= entities["Player"]["x"] == 0 ? 0 : 1
    when :right
      entities["Player"]["x"] += entities["Player"]["x"] == map_size-1 ? 0 : 1
    when :rest
      entities["Player"]["hp"] +=entities["Player"]["hp"] <entities["Player"]["max_hp"] ? 1 : 0
    when :quit
      puts "You ended game"
      break
    else
      puts " There is no such key!"
  end
  entities.each do |type,entity|#loop for checking collisions
       if entities["Player"]!=entity and onCollision(entities["Player"],entity)#if player is on another object
         entities["Player"]["Points"]+=entity["Points"]
          if(type=="Monster")
            entities["Player"]["hp"]-=1
          end
           entities.delete(type)#delete this entity
        end
  end
  if  entities["Player"]["hp"] <=0
    puts "GAME OVER"
    break
  end
  if !entities.key?("Monster")
    Add_monster(entities,map_size)
  end
end



