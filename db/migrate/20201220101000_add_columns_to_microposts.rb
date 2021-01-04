class AddColumnsToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :start_time, :time 
    add_column :microposts, :finish_time, :time
  end
end
