require "kramdown"

class Import
  def initialize(user:, path: File.join(Rails.root, "db", "import", "GoogleKeep"))
    @user = user
    @path = path
  end

  def call
    load_json_files
    index_by_name
    import
  end

  private

  attr_reader :path, :user, :json_files, :by_name

  def load_json_files
    @json_files = Dir["#{path}/**/*"].select { |file| file.ends_with?("json") }
  end

  def index_by_name
    @by_name = {}.tap do |hash|
      json_files.each do |file|
        basename = File.basename(file)
        name = basename.split(".").first
        hash[name] ||= file
      end
    end
  end

  def import
    user.notes.destroy_all

    by_name.each do |_title, path|
      json = read_parsed_json_file(path)
    
      note = build_text_note(json) if json.key?("textContent")
      note = build_list_note(json) if json.key?("listContent")

      if note
        set_title(json, note: note)
        add_tags(json, note: note)
        set_timestamps(json, note: note)
        note.save!
      end
    end
  end

  def read_parsed_json_file(path)
    data = nil
    File.open(path, "r") { |file| data = file.read }
    JSON.parse(data)
  end

  def build_text_note(json)
    text = json["textContent"]
    html = text_to_html(text)

    user.notes.build(
      markdown: text,
      html: html
    )
  end

  def build_list_note(json)
    text = json["listContent"][0]["text"]
    html = text_to_html(text)

    user.notes.build(
      markdown: text,
      html: html
    )
  end

  def set_title(json, note:)
    note.title = json["title"]
  end

  def text_to_html(text)
    return text unless text
    
    html = Kramdown::Document.new(text).to_html
    html.gsub("\n\n", "<br />").gsub("\n", "<br />")
  end

  def add_tags(json, note:)
    return unless json.key?("labels")

    note.tag_list = json["labels"].map { |label| label["name"] }.join(", ")
  end

  def set_timestamps(json, note:)
    note.created_at = Time.at(json["createdTimestampUsec"] / 1_000_000).to_datetime
    note.updated_at = Time.at(json["userEditedTimestampUsec"] / 1_000_000).to_datetime
  end
end

import = Import.new(user: User.first)
import.call