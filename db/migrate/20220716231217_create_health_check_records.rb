class CreateHealthCheckRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :health_check_records do |t|
      t.datetime :ran_at

      t.timestamps
    end
  end
end
