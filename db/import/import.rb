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

    by_name.each do |title, path|
      json = read_parsed_json_file(path)
    
      note = build_text_note(json, title: title) if json.key?("textContent")
      note = build_list_note(json, title: title) if json.key?("listContent")

      if note
        add_tags(json, note: note)
        note.save!
      end
    end
  end

  def read_parsed_json_file(path)
    data = nil
    File.open(path, "r") { |file| data = file.read }
    JSON.parse(data)
  end

  def build_text_note(json, title:)
    text = json["textContent"]
    html = text_to_html(text)

    user.notes.build(
      title: title,
      markdown: text,
      html: html
    )
  end

  def build_list_note(json, title:)
    text = json["listContent"][0]["text"]
    html = text_to_html(text)

    user.notes.build(
      title: title,
      markdown: text,
      html: html
    )
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
end

import = Import.new(user: User.first)
import.call