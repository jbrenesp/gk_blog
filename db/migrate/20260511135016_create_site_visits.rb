class CreateSiteVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :site_visits do |t|
      t.integer :visits_count

      t.timestamps
    end
  end
end
