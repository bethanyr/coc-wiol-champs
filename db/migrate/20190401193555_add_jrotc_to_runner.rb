class AddJrotcToRunner < ActiveRecord::Migration
  def change
    add_column :runners, :jrotc, :string
  end
end
