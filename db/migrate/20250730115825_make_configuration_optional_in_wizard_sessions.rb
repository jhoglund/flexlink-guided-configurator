class MakeConfigurationOptionalInWizardSessions < ActiveRecord::Migration[7.0]
  def change
    change_column_null :wizard_sessions, :configuration_id, true
  end
end
