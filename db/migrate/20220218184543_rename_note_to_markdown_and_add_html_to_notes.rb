class RenameNoteToMarkdownAndAddHtmlToNotes < ActiveRecord::Migration[7.0]
  def change
    rename_column :notes, :note, :markdown
    add_column :notes, :html, :text
  end
end
