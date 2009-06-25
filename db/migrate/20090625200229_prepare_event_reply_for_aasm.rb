class PrepareEventReplyForAasm < ActiveRecord::Migration
  def self.up
    change_table :event_replies do |t|
      t.string :aasm_state, :null => false
    end
  end

  def self.down
  end
end
