class MakeDataSaner < ActiveRecord::Migration
  def self.up
    superuser = User.find_by_email('patrik.stenmark@gmail.com')
    raise "no patrik" if superuser.nil?
    
    errored = []
    Event.all.each do |e|
      if e.owner.nil?
        e.update_attribute(:user_id, superuser.id)
      end
    end
    
    change_table :events do |t|
      t.change :user_id, :integer, :null => false
    end
  end

  def self.down
    change_table :events do |t|
    end
  end
end
