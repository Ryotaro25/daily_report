class AddStartTimeToMicroposts < ActiveRecord::Migration[6.0]
  def change
    add_column :microposts, :start_time, :datetime
  end
end
