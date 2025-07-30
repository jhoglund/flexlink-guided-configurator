class CreateWizardSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :wizard_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :configuration, null: false, foreign_key: true
      t.string :session_id, null: false
      t.integer :current_step, default: 1
      t.jsonb :step_data, default: {}
      t.jsonb :validation_errors, default: {}
      t.datetime :started_at
      t.datetime :last_activity_at
      t.datetime :completed_at
      t.string :status, default: 'active'

      t.timestamps null: false
    end

    add_index :wizard_sessions, :session_id, unique: true
    add_index :wizard_sessions, :current_step
    add_index :wizard_sessions, :status
    add_index :wizard_sessions, :step_data, using: :gin
    add_index :wizard_sessions, :validation_errors, using: :gin
  end
end 