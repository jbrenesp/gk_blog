class DropSiteVisits < ActiveRecord::Migration[8.1]
  def up
    drop_table :site_visits, if_exists: true
  end

  def down
    create_table :site_visits do |t|
      t.integer "visits_count"
      t.timestamps
    end
  end
end
