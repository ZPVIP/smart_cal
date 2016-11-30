
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
    @number.to_s
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
      when OperationType::DEC
        @number = @number.to_i * 10 + n
      when OperationType::HEX
        @number = @number.to_i * 16 + n
      when OperationType::BIN
        @number = @number.to_i * 2 + n
      end
    end

  end



  def press_cleara
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
    @mode = OperationType::Bin
  end

  def press_equals
    @number = @previous.send(@op, @number.to_i)
    @op = nil
  end

end

number_field = nil
number = Smart_Cal.new
Shoes.app :height => 300, :width => 200, :resizable => false do
  background "#EEC".."#996", :curve => 5, :margin => 2

  stack :margin => 2 do

    stack :margin => 8 do
      number_field = para strong(number)
    end

    flow :width => 218, :margin => 4 do
      %w(7 8 9 / 4 5 6 * 1 2 3 - 0 Clr = + / a b c d e f).each do |btn|
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
          number_field.replace strong(number)
        end
      end
    end
  end

end
