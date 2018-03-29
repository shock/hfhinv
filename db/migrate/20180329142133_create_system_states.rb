class CreateSystemStates < ActiveRecord::Migration[5.1]
  def change
    create_table :system_states do |t|
      t.string :name
      t.text :serial_data

      t.timestamps
    end
    SystemState.find_or_create_by(name: 'state')
  end
end
