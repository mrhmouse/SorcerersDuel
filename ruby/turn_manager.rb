
require 'wizard'
require 'spells/spell_book'
$, =","
class TurnManager
  attr_reader   :wizards    
  attr_writer 

  def initialize(wizards)
    @wizards = wizards
    @spell_book = SpellBook.get_spell_book
  end

  #The command line version - ultimately the input will come from the UI
  def get_turn_gestures
    @wizards.each do |wiz|
      puts "gestures for #{wiz}"
      puts "Enter #{wiz}'s left hand commands: (action, target)"
      commands = gets
      gesture,target = commands.split(/,/)
      target.chomp unless target == nil
      wiz.action_left(gesture.chomp,target) 
      
      puts "Enter #{wiz}'s right hand commands: (action, target)"
      commands = gets
      gesture,target = commands.split(/,/)
      target.chomp unless target == nil
      wiz.action_right(gesture.chomp,target) 
      #puts "Enter #{wiz}'s right hand gesture"
      #wiz.gesture_right(gets)
    end
  end

  def invoke_spells
    a = []  
    @wizards.each do |wiz|
       invoked_list = @spell_book.invoke_spell([wiz.left_hand_gestures,wiz.right_hand_gestures])
       invoked_list.each_index do |listIndex|
        if(invoked_list[listIndex].length > 1)
          puts "More than one spell invoked on hand: please choose one -- #{invoked_list[listIndex]}"
          selected_index = gets.to_i          
          invoked_list[listIndex] = [invoked_list[listIndex][selected_index]] 
        end
       end
       wiz.invoked_spells = invoked_list
    end
    a
  end

  def resolve_turn
    
  end
end




if __FILE__ == $0
  thor = Wizard.new("Thor")
  
  #mages = [Wizard.new("Thor"), Wizard.new("Ruf")]
  tm = TurnManager.new([thor])
  tm.get_turn_gestures
  right_hand_spells, left_hand_spells = tm.invoke_spells
  #puts "#{right_hand_spells} <-> #{left_hand_spells}"
  puts "#{thor}'s left hand conjures: #{thor.invoked_left_hand_spells}" 
  puts "#{thor}'s right handed conjures: #{thor.invoked_right_hand_spells}" 
end