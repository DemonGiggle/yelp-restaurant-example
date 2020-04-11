class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false, comment: 'Restaurant name'

      t.timestamps
    end

    create_table :periods do |t|
      t.belongs_to :restaurant, null: false
      t.integer    :weekdays,   null: false, array: true, default: [], comment: 'weekdays (UTC), corresponding to #wday'
      t.string     :hour_start, null: false,                           comment: 'start of the hour (UTC), always 4 chars, 24hour notation'
      t.string     :hour_end,   null: false,                           comment: 'end of the hour (UTC), always 4 chars, 24hour notation'

      t.timestamps
    end

    add_index :periods, :weekdays
    add_index :periods, :hour_start
    add_index :periods, :hour_end
  end
end
