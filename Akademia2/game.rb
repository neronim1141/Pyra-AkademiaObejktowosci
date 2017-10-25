#create map
map_size = 10 # x*x
world = Array.new(10){Array.new(10," ")}
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
        "x"=>5,
        "y"=>5,
        "hp"=>10
    },
    "Monster"=>{
        "Texture"=>"M",
        "x"=>3,
        "y"=>2,
        "points"=>2
    }
}

def Draw_hp(hp) #draw hp of entity
  hp.times do
    print "▌ "
  end
  puts
end

def onCollision(obj1,obj2)#check collision
  if(obj1["x"]==obj2["x"] and obj1["y"]==obj2["y"])
    return true
  else
    return false
  end
end

#player points
points=0

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

def Render(world,entities,points,keys) #render screen
  system "clear"
  puts "punkty: " + points.to_s
  Put_entities(world,entities)
  Render_world(world)
  Restore_world(world,entities)
  Draw_hp(entities["Player"]["hp"])
  Instruction(keys)
end



while(true)#execute endlessly unless player dont quit
  Render(world,entities,points,keys)
  action = gets.chomp#czekaj na znak
  case keys[action.downcase]
    when :up
      entities["Player"]["y"] -= 1
    when :down
      entities["Player"]["y"] += 1
    when :left
      entities["Player"]["x"] -= 1
    when :right
      entities["Player"]["x"] += 1
    when :rest
      entities["Player"]["hp"] +=entities["Player"]["hp"] <10 ? 1 : 0
    when :quit
      break
    else
      puts " nie ma takiego klawisza!"
  end
  entities.each do |_,entity|#sprawdzaj kolizje

       if entities["Player"]!=entity and onCollision(entities["Player"],entity)#w wypadku zderzenia sie

          points+=entity["points"]

           entities.delete(_)#usun dany obiekt
        end

       end
end



