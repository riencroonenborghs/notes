class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes
  def index
    @notes = current_user.notes.order(created_at: :desc).page(params[:page])
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = current_user.notes.build
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = current_user.notes.build(note_params)

    if @note.save
      redirect_to notes_path, notice: "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to notes_path, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    redirect_to notes_path, notice: "Note was successfully destroyed."
  end

  def tagged
    @tag_name = params[:tag].downcase
    @notes = current_user.notes.tagged_with(@tag_name).order(created_at: :desc).page(params[:page])
  end

  def search
    @query = params.require(:note).permit(:query)[:query]

    service = SearchService.call(
      user: current_user,
      query: @query,
      page: params[:page]
    )
    @notes = service.notes
  end

  private
    
  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = current_user.notes.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :markdown, :html, :tag_list, :image)
  end
end
