
#require 'green_shoes'
require_relative 'smart_cal_base' 

number_field = nil
mode_field = nil
number = Smart_Cal.new

list = Array.new
32.times do |i|
   list.insert(-1, "bit#{i}")
end

Shoes.app :height => 320, :width => 600, :resizable => false , :scroll => false do
  background "#EEC".."#996", :curve => 5, :margin => 2

  stack :margin => 2 do

    flow :width => 540, :margin => 4 do
      flow :width => 0.1 do
      mode_field = para strong(number.mode)
      end
      flow :width => 0.9 do
        number_field = para strong(number.to_s)
      end

    end

    
    flow :width => 540, :margin => 4 do
      list.map! do |name|
        flow :width => 0.125 do @c = check; para name end
        [@c, name]
      end
    end

    flow :width => 540, :margin => 4 do
      %w(1 2 3 4 5 6 7 8 9 / * - Clr + = 0 a b c d e f hex dec bin).each do |btn|
        button btn, :width => 46, :height => 46 do
          method = case btn
            when /[0-9]/; 'press_'+btn
            when 'Clr'; 'press_clear'
            when '='; 'press_equals'
            when '+'; 'press_add'
            when '-'; 'press_sub'
            when '*'; 'press_times'
            when '/'; 'press_div'
            when /[a-f]/; 'press_'+btn
          end
          
          number.send(method)
          number_field.replace strong(number.to_s)
          mode_field.replace strong(number.mode)
        end
      end
    end
  end

end
