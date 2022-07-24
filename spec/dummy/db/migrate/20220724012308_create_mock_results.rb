class CreateMockResults < ActiveRecord::Migration[7.0]
  def change
    create_table :mock_results do |t|

      t.timestamps
    end
  end
end
