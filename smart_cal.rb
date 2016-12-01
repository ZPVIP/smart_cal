
#require 'green_shoes'

class String
  def from_hex
    self.to_i(16)
  end

  def from_bin
    self.to_i(2)
  end
  
  def from_dec
    self.to_i 
  end
end

class Fixnum
    def to_hex
        self.to_s(16) 
    end
    def to_bin
        self.to_s(2)
    end
    def to_dec
        self.to_s
    end
end


class Smart_Cal
  module OperationType
    HEX = 1
    DEC = 2
    BIN = 3
  end
  def initialize
    @number = 0
    @previous = nil
    @op = nil
    @mode = OperationType::DEC
  end

  def to_s
    case @mode
      when OperationType::DEC
        @number.to_dec
      when OperationType::HEX
        @number.to_hex
      when OperationType::BIN
        @number.to_bin
    end
  end

  def mode
    case @mode
      when OperationType::DEC
        ""
      when OperationType::HEX
        "0x"
      when OperationType::BIN
        "0B"
    end
  end

  
  (0..9).each do |n|
    define_method "press_#{n}" do
      case @mode
      when OperationType::DEC
        @number = @number.to_i * 10 + n
      when OperationType::HEX
        @number = @number.to_i * 16 + n
      when OperationType::BIN
        @number = @number.to_i * 2 + n
      end
    end
  end

  ('a'..'f').each do |n|
    define_method "press_#{n}" do
      case @mode
      when OperationType::HEX
        @number = @number.to_i * 16 + n.from_hex
      end
    end

  end


  def press_clear
    @number = 0
  end

  {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
    define_method "press_#{meth}" do
     if @op
        press_equals
      end
      @op = op
      @previous, @number = @number, nil
    end
  end

  def press_hex
    @mode = OperationType::HEX
  end

  def press_dec
    @mode = OperationType::DEC
  end

  def press_bin
    @mode = OperationType::BIN
  end

  def press_equals
    puts @number.class
    @number = @previous.send(@op, @number)
    @op = nil
  end

end

number_field = nil
mode_field = nil
number = Smart_Cal.new

list = Array.new
32.times do |i|
   list.insert(-1, "bit#{i}")
end

Shoes.app :height => 300, :width => 600, :resizable => false do
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
      %w(7 8 9 / 4 5 6 * 1 2 3 - 0 Clr = + a b c d e f hex dec bin).each do |btn|
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
