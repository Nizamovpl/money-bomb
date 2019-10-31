require 'gosu'

#maybe later on add rockets to change y direction
#keep track of money
#click/press keys to restart
#larger amounts of money fall more rarely and slowly
#click/press keys to start/reset


class Game < Gosu::Window
    def initialize
        super 1920,1080
        
        @background_image = Gosu::Image.new("media/sky_background.png", :tileable => true)
        @player = Player.new
        @score = 0
        @money = Gosu::Image.new("media/temp.bmp")

        @font = Gosu::Font.new(20)
    end

    def update
        if Gosu.button_down? Gosu::KB_D #move right
            @player.move_right
        end

        if Gosu.button_down? Gosu::KB_A #move left
            @player.move_left
        end

    end


    def draw
        @background_image.draw(0, 0, 0) #, ZOrder::BACKGROUND
        @player.draw
        @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
        # @font.draw("Number of rockets:#{@player.rockets, 10, 10, 1.0.1.0, Gosu::Color::YELLOw")

    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE                                                             #add module later
          @font.draw("press q to quit game : press 2 to restart: press 3 to return", 10, 10, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
            if id== Gosu::KB_1
                close
            elsif
                Game.new
            elsif
                super
            end
        else 
          super 
        end
      end



end



class Player

    def initialize
        @player = Gosu::Image.new("media/tempplay.png")
        @x = @vel_x = @angle = 0.0
    end

    def accelerate
        @vel_x +=Gosu.offset_x(@angle, 0.5)
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
        money.reject! do |money| #reject loop makes the money disappear when gone
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



end



class Large_Money





end


class Rocket 

    def initialize
        @image = Gosu::Image.new("media/temprocket.png")
        @x = rand*1920
        @y = rand*1080

    end
    
    
    def rocket_collection
        rocket.reject! do |rocket| #reject loop makes the money disappear when gone
            if Gosu.distance(@x, @y ,money.x, money.y) < 35
              @score += 1
              true
            else
              false
            end
        end



    end
    


    def draw
        @rocket.draw
    end


end


Game.new.show


