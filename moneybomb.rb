require 'gosu'

#click/press keys to start/reset
#ckeck spelling errors
# https://www.rubydoc.info/github/gosu/gosu/master/Gosu/Image - There are so many problems with adding draw arguments \\
#color classes https://www.rubydoc.info/github/gosu/gosu/Gosu/Color 
#Do this after finishing up all the logic 
#add pausing mechanism once everything else is sorted out

#draw(x, y, z, scale_x = 1, scale_y = 1, color = 0xff_ffffff, mode = :default) ⇒ void
class Game < Gosu::Window 
    def initialize
        super 1920,1080
        
        @background_image = Gosu::Image.new("media/sky_background.png", :tileable => true)
        @money = Money.new
        @large_money = Lager_Money.new
        @rocket = Rocket.new
        @bomb = Bomb.new 

        @player = Player.new
        @score = 0   
        @player.warp(960, 180)
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

        if Gosu::button_down? Gosu::KB_Q and @rocket > 0  #rocket
            @player.play_launch
            @rocket -= 1
        end

        if rand(100) < 4 and @money.size < 50  #spawn rates
            @money.push(Money.new)
        end
        
        if rand(100) < 4 and @rocket.size < 3
            @rocket.push(Rocket.new)
        end

        if rand(100) < 4 and @large_money.size < 10
            @large_money.push(Large_Money.new)
        end
    end

    def restart #resetting the game
        @game_over = false  
        @rocket.clear
        @money.clear
        @large_money.clear
        @score = 0
        @player.warp(960, 180)
    end


    def game_over
        if @game_over == true
            @font.draw("press q to quit game : press 2 to restart: press 3 to return", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            if Gosu::button_down? == KB_2 
                restart
            elsif Gosu::button_down? == KB_Q
                super
            elsif Gosu::button_down? == KB_3
                @font.clear
            end
        end




    end


    def draw
        @background_image.draw(0, 0, ZOrder::BACKGROUND) #, ZOrder::BACKGROUND
        @player.draw
        @money.draw
        @large_money.draw
        @rocket.draw
        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        @font.draw("Number of rockets:#{@player.rocket}", 10, 10,ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)

    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
          @font = Gosu::Font.new(20)                                                       
          @font.draw("press q to quit game : press 2 to restart: press 3 to return", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            if id== Gosu::KB_Q
                close
            elsif id ==KB_2    #add the 3000 milltion cases
                restart
            elsif id == KB_3
                @font.clear
            end
        else 
          super 
        end
    end



end





class Player
    attr_reader :x, :y
    def initialize
        @image = Gosu::Image.new("media/tempplay.png")
        @x = @vel_x = @angle = 0.0
    end

    def accelerate
        @vel_x +=Gosu.offset_x(@angle, 0.5)
        @vel_y +=Gosu.offset_y(@angle, 0.5)
    end

    def warp(x,y)
        @x,@y = x, y
    end

    def move_right
        # @angle = 4.5
        @x += @vel_x
        @x %= 1920
        @vel_x *= 0.3
    end

    def move_left
        @x -= @vel_x
        @x %= 1920

        @vel_x *= 0.3
    end

    def play_launch 
        timecounter = 0
        while timecounter < 4
            @y+=vel_y
            1.second
            timecounter += 4
        end

        if timecounter == 4
            until @y == 180 do 
                @y -= vel_y
            end
            
            timecounter = 0 
        end
    end

    def draw 
        @image.draw(@x,@y,1)
    end


end

class Money  
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

    def draw
        @image.draw(@x, @y, 1)
        @background_image.draw(0, 0, 0)
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
        @image = Gosu::Image.new("media/tempbomb.bmp")
        @x = rand*1920
        @y = 1080

    end

    def drop
        until @y == 0 # or the player collects the money 
            @y -= vel_y
        end 
    end


    def draw 
        @image.draw(@x, @y, 1)
        @background_image.draw(0, 0, 0)

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

    def draw
        @image.draw(@x, @y, 1)
        @background_image.draw(0, 0, 0)


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
        rocket.reject! do |rocket| #reject loop makes the money disappear when gone #test to see whether there are multiple rockets spawning
            if Gosu.distance(@x, @y ,rocket.x, rocket.y) < 3
              @rocket += 1
              true
            else
              false
            end
        end
    end
    


    def draw
        @image.draw(@x, @y, 1)
        @background_image.draw(0, 0, 0)
    end


end


module ZOrder
    BACKGROUND, BOMB, PLAYER, UI = *0..3  #large money #money #rocket
end
  

Game.new.show


