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
    @full_width = 600
    @full_height = 400
    @smart_cal = Smart_Cal.new
    # Invoke base class initialize first
    super(app, "SmartCAL", :opts => DECOR_ALL, :width => @full_width, :height => @full_height)

    @numbButton = Array.new(10) # 0 -9
    @hexButton  = Hash.new()  # a- f
    @opButton   = Hash.new()  # + - x / & |
    @funcButton = Hash.new()  # cls = back hex bin dec


    # Contents
    contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X)


    @mode = FXLabel.new(contents, "Dec", nil,
      LAYOUT_SIDE_TOP| JUSTIFY_LEFT)


    @optionTarget = FXDataTarget.new(@smart_cal.number)
    @input = FXTextField.new(contents, 1, @optionTarget, FXDataTarget::ID_VALUE,
      (TEXTFIELD_NORMAL|JUSTIFY_RIGHT|LAYOUT_FILL_ROW|LAYOUT_SIDE_TOP|LAYOUT_FILL_X))
    # Button to pop normal dialog
    FXHorizontalSeparator.new(self,
      LAYOUT_NORMAL|LAYOUT_FILL_X|SEPARATOR_GROOVE)

        # Controls on the right
    controls = FXVerticalFrame.new(self,
      LAYOUT_SIDE_RIGHT|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)

    matrix = FXMatrix.new(self, 5,
      MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FIX_WIDTH, :width => getwidth(55) ) 

    (0..9).each do |n|
      @numbButton[n] = FXButton.new(matrix,
        "#{n}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @numbButton[n].connect(SEL_COMMAND, method("press_#{n}".to_sym))
      @optionTarget = @smart_cal.number.to_s
    end

    ('a'..'f').each do |n|
      @hexButton[n] = FXButton.new(matrix,
        "#{n}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @hexButton[n].connect(SEL_COMMAND, method("press_#{n}".to_sym))
      @optionTarget = @smart_cal.number.to_s
    end

    {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
      @opButton[meth] = FXButton.new(matrix,
        "#{op}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(10))
      @opButton[meth].connect(SEL_COMMAND, method("press_#{meth}".to_sym))   
      @optionTarget = @smart_cal.number.to_s  
    end

    matrix_right = FXMatrix.new(controls, 2,
      MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP)

    # cls back hex bin dec =
    ['cls', 'back', 'hex', 'bin', 'dec', 'equals'].each do |meth|
      @funcButton[meth] = FXButton.new(matrix_right,
        "#{meth}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(20))
      @funcButton[meth].connect(SEL_COMMAND, method("press_#{meth}".to_sym))
      @optionTarget = @smart_cal.number.to_s
      @mode.text = @smart_cal.mode 
    end
  end

  (0..9).each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      @smart_cal.send("press_#{n}")
      @optionTarget = @smart_cal.number.to_s 
    end
  end

  ('a'..'f').each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      @smart_cal.send("press_#{n}")
      @optionTarget = @smart_cal.number.to_s
    end
  end

  {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
    define_method "press_#{meth}" do |sender, sel, ptr|
      @smart_cal.send("press_#{meth}")
      @optionTarget = @smart_cal.number.to_s
    end
  end

  ['cls', 'equals', 'back', 'hex', 'bin', 'dec'].each do |meth|
    define_method "press_#{meth}" do |sender, sel, ptr|
      @smart_cal.send("press_#{meth}")
      @optionTarget = @smart_cal.number.to_s
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