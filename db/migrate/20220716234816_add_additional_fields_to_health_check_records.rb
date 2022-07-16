class AddAdditionalFieldsToHealthCheckRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :health_check_records, :health_check_name, :string, null: false
  end
end
