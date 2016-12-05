
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
attr_accessor :number, :mode
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
    return if @number.nil?
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
        "0b"
    end
  end

  def bit_on?(name)
    temp = name.gsub("bit", "")
    if @number.to_bin().chars[temp.to_i] == '1'
      true
    else
      false
    end
  end

  def add_bit(name)
     temp = name.gsub("bit", "")
     @number = @number + temp + 1
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
    return if @previous.nil?
    return if @number.nil?
    return if @op.nil?
    @number = @previous.send(@op, @number)
    @op = nil
  end

  def press_back
    @number = @number / 10
  end

end

