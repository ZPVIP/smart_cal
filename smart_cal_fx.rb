#!/usr/bin/env ruby

require 'fox16'
require_relative 'smart_cal_base' 

include Fox

# A little dialog box to use in our tests
class FXTestDialog < FXDialogBox

  def initialize(owner)
    # Invoke base class initialize function first
    super(owner, "Test of Dialog Box", DECOR_TITLE|DECOR_BORDER)

    # Bottom buttons
    buttons = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH,
      :padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)

    # Separator
    FXHorizontalSeparator.new(self,
      LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|SEPARATOR_GROOVE)

    # Contents
    contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)

    submenu = FXMenuPane.new(self)
    FXMenuCommand.new(submenu, "One")
    FXMenuCommand.new(submenu, "Two")
    FXMenuCommand.new(submenu, "Three")

    # Menu
    menu = FXMenuPane.new(self)
    FXMenuCommand.new(menu, "&Accept", nil, self, ID_ACCEPT)
    FXMenuCommand.new(menu, "&Cancel", nil, self, ID_CANCEL)
    FXMenuCascade.new(menu, "Submenu", nil, submenu)
    FXMenuCommand.new(menu, "&Quit\tCtl-Q", nil, getApp(), FXApp::ID_QUIT)

    # Popup menu
    pane = FXPopup.new(self)
    %w{One Two Three Four Five Six Seven Eight Nine Ten}.each do |s|
      FXOption.new(pane, s, :opts => JUSTIFY_HZ_APART|ICON_AFTER_TEXT)
    end

    # Option menu
    FXOptionMenu.new(contents, pane, (FRAME_RAISED|FRAME_THICK|
      JUSTIFY_HZ_APART|ICON_AFTER_TEXT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y))

    # Button to pop menu
    FXMenuButton.new(contents, "&Menu", nil, menu, (MENUBUTTON_DOWN|
      JUSTIFY_LEFT|LAYOUT_TOP|FRAME_RAISED|FRAME_THICK|ICON_AFTER_TEXT|
      LAYOUT_CENTER_X|LAYOUT_CENTER_Y))

    # Accept
    accept = FXButton.new(buttons, "&Accept", nil, self, ID_ACCEPT,
      FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)

    # Cancel
    FXButton.new(buttons, "&Cancel", nil, self, ID_CANCEL,
      FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)

    accept.setDefault
    accept.setFocus
  end

end


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
    # Invoke base class initialize first
    super(app, "Dialog SmartCAL", :opts => DECOR_ALL, :width => @full_width, :height => @full_height)

    @numbButton = Array.new(10) # 0 -9
    @hexButton  = Hash.new()  # a- f
    @opButton   = Hash.new()  # + - x / & |
    @funcButton = Hash.new()  # cls = back hex bin dec


    # Contents
    contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH)

    # Controls on the right
    controls = FXVerticalFrame.new(self,
      LAYOUT_SIDE_RIGHT|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)

    @mode = FXLabel.new(contents, "Dec", nil,
      LAYOUT_SIDE_TOP|JUSTIFY_LEFT)
    @optionTarget = FXDataTarget.new(1)
    @input = FXTextField.new(contents, 1, @optionTarget, FXDataTarget::ID_VALUE,
      (TEXTFIELD_NORMAL|JUSTIFY_RIGHT|LAYOUT_FILL_ROW|LAYOUT_SIDE_TOP|LAYOUT_FILL_X))
    # Button to pop normal dialog
    FXHorizontalSeparator.new(self,
      LAYOUT_NORMAL|LAYOUT_FILL_X|SEPARATOR_GROOVE)

    matrix = FXMatrix.new(self, 5,
      MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP|LAYOUT_FIX_WIDTH, :width => getwidth(55) ) 

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
      MATRIX_BY_COLUMNS|LAYOUT_SIDE_TOP)

    # cls back hex bin dec =
    ['cls', 'back', 'hex', 'bin', 'dec', '='].each do |meth|
      @funcButton[meth] = FXButton.new(matrix_right,
        "#{meth}",
        :opts => FRAME_RAISED|FRAME_THICK|LAYOUT_NORMAL|JUSTIFY_CENTER_X|LAYOUT_FIX_WIDTH, :width => getwidth(20))
      @funcButton[meth].connect(SEL_COMMAND, method("press_#{meth}".to_sym))      
    end 
  end

  (0..9).each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      puts "test"
    end
  end

  ('a'..'f').each do |n|
    define_method "press_#{n}" do |sender, sel, ptr|
      puts "test"
    end
  end

  {'add' => '+', 'sub' => '-', 'times' => '*', 'div' => '/'}.each do |meth, op|
    define_method "press_#{meth}" do |sender, sel, ptr|
      puts "test"
    end
  end

  ['cls', '=', 'back', 'hex', 'bin', 'dec'].each do |meth|
    define_method "press_#{meth}" do |sender, sel, ptr|
      puts "test"
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