class CreateRunners < ActiveRecord::Migration
  def change
    create_table :runners do |t|
      t.integer :database_id
      t.string :surname
      t.string :firstname
      t.string :gender
      t.string :school
      t.string :school_short
      t.string :entryclass
      t.string :class_category
      t.boolean :non_compete1
      t.time :time1
      t.float :float_time1
      t.string :classifier1
      t.boolean :non_compete2
      t.time :time2
      t.float :float_time2
      t.string :classifier2
      t.time :total_time
      t.float :float_total_time
      t.float :day1_score
      t.float :day2_score
      t.float :total_score

      t.timestamps
    end
  end
end
