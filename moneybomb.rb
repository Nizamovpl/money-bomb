require 'gosu'
#click/press keys to restart
#larger amounts of money fall more rarely and slowly
#click/press keys to start/reset



#add Z order module once you figure out what it does

class Game < Gosu::Window #player warp at somepoint ; so player doesn't spawn in air
    def initialize
        super 1920,1080
        
        @background_image = Gosu::Image.new("media/sky_background.png", :tileable => true)
        @player = Player.new
        @score = 0   #keep track of money
        @money = Gosu::Image.new("media/temp.bmp")
        @large_money = Gosu::Image.new("media/templarge.bmp")
        @rocket = Gosu::Image.new("media/temprock.bmp")
        @bomb = Gosu::Image.new("media.tempbomb.png")
        @game_over = false
        @font = Gosu::Font.new(20)
    end

    def update
        if Gosu.button_down? Gosu::KB_D #move right
            @player.move_right
        end

        if Gosu.button_down? Gosu::KB_A #move left
            @player.move_left
        end

        if GOSU::button_down? Gosu::KB_Q and @rocket > 0
            @player.play_launch
            @rocket -= 1

        end

    end


    def draw
        @background_image.draw(0, 0, 0) #, ZOrder::BACKGROUND
        @player.draw
        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw("Number of rockets:#{@player.rocket}", 10, 10, 1.0.1.0, Gosu::Color::YELLOW)

    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE                                                             #add module later
          @font.draw("press q to quit game : press 2 to restart: press 3 to return", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            if id== Gosu::KB_1
                close
            elsif id ==    #add the 3000 milltion cases
                Game.new
            elsif id == 
                super
            end
        else 
          super 
        end
      end



end




#add a draw function for some of these, this child was too lazy to right now
class Player

    def initialize
        @player = Gosu::Image.new("media/tempplay.png")
        @x = @vel_x = @angle = 0.0
    end

    def accelerate
        @vel_x +=Gosu.offset_x(@angle, 0.5)
        @vel_y +=Gosu.offset_y(@angle, 0.5)
    end

    def move_right
        # @angle = 4.5
        @x += @vel_x
        @x %= 1152
        @vel_x *= 0.3
    end

    def move_left
        @x -= @vel_x
        @x %= 1920

        @vel_x *= 0.3
    end

    def play_launch #player needs to drop back down
        timecounter = 0
        while timecounter < 4
            @y+=vel_y
            1.second
            timecounter += 4
        end
    end

    def draw
        @player.draw
        @background_image.draw(0, 0, 0)

    end


end

class Money  #add y velocity that goes down
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("media/temp.png")
        @x = rand*1920
        @y = 1080
    end

    def drop
        until @y == 0 # or the player collects the money 
            @y -= vel_y
        end 
    end


    def collect_money
        large_money.reject! do |large_money| #reject loop makes the money disappear when gone
            if Gosu.distance(@x, @y ,money.x, money.y) < 35
              @score += 1
              true
            else
              false
            end
        end
    end



end



class Bomb
    attr_reader :x, :y


    def initialize

    end

    def drop


    end

    def explode
        def collect_money
            bomb.reject! do |bomb| 
                if Gosu.distance(@x, @y ,money.x, money.y) < 35
                  @game_over = true
                  true
                else
                  false
                end
            end
        end
    



    end



end



class Large_Money #alter spawn rates
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("media/templarge.png")
        @x = rand*1920
        @y = 1080
    end

    def drop
        until @y == 0 # or the player collects the money 
            @y -= vel_y
        end 
    end


    def collect_money_larger
        money.reject! do |money| #reject loop makes the money disappear when gone
            if Gosu.distance(@x, @y ,money.x, money.y) < 35
              @score += 10
              true
            else
              false
            end
        end
    end

end


class Rocket  #alter spawn rates
    attr_reader :x, :y

    def initialize
        @image = Gosu::Image.new("media/temprocket.png")
        @x = rand*1920
        @y = rand*1080

    end
    
    
    def rocket_collection
        rocket.reject! do |rocket| #reject loop makes the money disappear when gone
            if Gosu.distance(@x, @y ,rocket.x, rocket.y) < 3
              @rocket += 1
              true
            else
              false
            end
        end
    end
    


    def draw
        @rocket.draw
        @background_image.draw(0, 0, 0
    end


end


class game_over

   if @game_over = true
        @font.draw("You have failed, press q to exit, press esc to close") #add restart and close otions
    end




end


Game.new.show


