#!/usr/bin/env ruby

require 'fox16'
require_relative 'smart_cal_base' 

include Fox


# Subclassed main window
class SamrtCal < FXMainWindow

  def getwidth(per)
    @full_width * per / 100 
  end

  def getheight(per)
    @full_width * per / 100
  end
  
  def initialize(app)
    @full_width = 620
    @full_height = 420
    @smart_cal = Smart_Cal.new
    # Invoke base class initialize first
    super(app, "SmartCAL", :opts => DECOR_ALL, :width => @full_width, :height => @full_height)

    @numbButton = Array.new(10) # 0 -9
    @hexButton  = Hash.new()  # a- f
    @opButton   = Hash.new()  # + - x / & |
    @funcButton = Hash.new()  # cls = back hex bin dec
    @bitButton  = Hash.new()


    matrix_top = FXMatrix.new(self, 1,
    MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FIX_WIDTH, :width => getwidth(100)) 
    # Contents
    contents = FXHorizontalFrame.new(matrix_top,
      LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT, :width => getwidth(100), :height => getheight(5))

    @mode = FXLabel.new(contents, "0d", nil,
      LAYOUT_SIDE_TOP|JUSTIFY_LEFT|LAYOUT_FIX_WIDTH, :width => getwidth(10))

    @optionTarget = FXDataTarget.new(@smart_cal.number)
    @input = FXTextField.new(contents, 1, @optionTarget, FXDataTarget::ID_VALUE,
      (TEXTFIELD_NORMAL|JUSTIFY_RIGHT|LAYOUT_FILL_ROW|LAYOUT_SIDE_TOP|LAYOUT_FILL_X))
    # Button to pop normal dialog

    FXHorizontalSeparator.new(matrix_top,
      LAYOUT_NORMAL|LAYOUT_FILL_X|SEPARATOR_GROOVE)

    matrix_mid = FXMatrix.new(self, 2,
    MATRIX_BY_COLUMNS|LAYOUT_FIX_WIDTH, :width => getwidth(100)) 

    matrix = FXMatrix.new(matrix_mid, 5,
      MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FIX_WIDTH, :width => getwidth(55) ) 

    # Controls on the right
    controls = FXVerticalFrame.new(matrix_mid,
      LAYOUT_SIDE_RIGHT)

    (0..9).each do |n|
      @numbButton[n] = FXButton.new(matrix,
        "#{n}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @numbButton[n].connect(SEL_COMMAND, method("press_#{n}".to_sym))
    end

    ('a'..'f').each do |n|
      @hexButton[n] = FXButton.new(matrix,
        "#{n}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @hexButton[n].connect(SEL_COMMAND, method("press_#{n}".to_sym))
    end

    {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
      @opButton[meth] = FXButton.new(matrix,
        "#{op}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @opButton[meth].connect(SEL_COMMAND, method("press_#{meth}".to_sym))    
    end

    matrix_right = FXMatrix.new(controls, 2,
      MATRIX_BY_COLUMNS|LAYOUT_FIX_WIDTH, :width => getwidth(40) )

    # clear back hex bin dec =
    ['clear', 'back', 'hex', 'bin', 'dec', 'equals'].each do |meth|
      @funcButton[meth] = FXButton.new(matrix_right,
        "#{meth}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(15))
      @funcButton[meth].connect(SEL_COMMAND, method("press_#{meth}".to_sym))
    end

    #
    matrix_bits = FXMatrix.new(self, 8,
    MATRIX_BY_COLUMNS|LAYOUT_FIX_WIDTH, :width => getwidth(100) )
    (0..63).each do |n|
       @bitButton[n] = FXCheckButton.new(matrix_bits, "bit#{n}", nil, 0,
        ICON_BEFORE_TEXT|LAYOUT_SIDE_TOP|LAYOUT_FIX_WIDTH, :width => getwidth(10))
       @bitButton[n].connect(SEL_COMMAND, method("press_bit#{n}".to_sym))
       if @smart_cal.bit_on?("bit#{n}")
        @bitButton[n].setCheck(true)
       end
    end

  end

  def update_bits
    (0..63).each do |n|
      if @smart_cal.bit_on?("bit#{n}")
        @bitButton[n].setCheck(true)
      else
        @bitButton[n].setCheck(false)
      end
    end
  end

  (0..63).each do |n|
    define_method "press_bit#{n}" do |sender, sel, ptr|
      if @bitButton[n].checked?
        @smart_cal.send("set_bit","bit#{n}")
      else 
        @smart_cal.send("cls_bit","bit#{n}")
      end
      @optionTarget.value = @smart_cal.to_s
    end
  end  

  (0..9).each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      @smart_cal.send("press_#{n}")
      @optionTarget.value = @smart_cal.to_s
      update_bits()
    end
  end

  ('a'..'f').each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      @smart_cal.send("press_#{n}")
      @optionTarget.value = @smart_cal.to_s
      update_bits()
    end
  end

  {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
    define_method "press_#{meth}" do |sender, sel, ptr|
      @smart_cal.send("press_#{meth}")
      @optionTarget.value = @smart_cal.to_s
      update_bits()
    end
  end

  ['clear', 'equals', 'back', 'hex', 'bin', 'dec'].each do |meth|
    define_method "press_#{meth}" do |sender, sel, ptr|
      @smart_cal.send("press_#{meth}")
      @optionTarget.value = @smart_cal.to_s
      @mode.text = @smart_cal.mode
      update_bits()
    end
  end
  # Start
  def create
    super
    show(PLACEMENT_SCREEN)
  end
end

def run
  # Make an application
  application = FXApp.new("Dialog", "Smart_cal")

  # Construct the application's main window
  SamrtCal.new(application)

  # Create the application
  application.create

  # Run the application
  application.run
end

run