class SearchService < AppService
  attr_reader :notes

  def initialize(user:, query:, page:)
    @user = user
    @query = query#.upcase
    @page = page
    @notes = []
  end

  def call
    scope = user
      .notes
      .order(created_at: :desc)

    title_scope = scope.where("upper(title) like ?", "%#{query}%")
    content_scope = scope.where("upper(markdown) like ?", "%#{query}%")

    @notes = title_scope.or(content_scope)
  end

  private

  attr_reader :user, :query, :page
end
