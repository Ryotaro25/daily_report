class RenameStartTimeColumnToMicroposts < ActiveRecord::Migration[6.0]
  def change
    rename_column :microposts, :start_time, :work_start
  end
end
