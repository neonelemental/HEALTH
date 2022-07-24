class RenameHealthCheckRecordsToHealthCheckRun < ActiveRecord::Migration[7.0]
  def change
    rename_table :health_check_records, :health_check_runs
  end
end
