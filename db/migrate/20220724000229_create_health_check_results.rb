class CreateHealthCheckResults < ActiveRecord::Migration[7.0]
  def change
    create_table :health_check_results do |t|
      t.references :resultable, polymorphic: true
      t.integer :health_check_run_id, null: false

      t.timestamps
    end

    add_foreign_key :health_check_results, :health_check_runs
  end
end
