class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
