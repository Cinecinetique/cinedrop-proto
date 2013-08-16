class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all
  end

  # GET /documents/1
  # GET /documents/1.json
  def show

    logger.info "document file name: #{@document.data_file_name}"
  end

  # GET /documents/new
  def new
    @document = Document.new
    @project_id = params[:project_id]
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    if document_params[:data].content_type == 'application/pdf'
      @document = Pdf.new(document_params)
    elsif Msword.content_types.include?(document_params[:data].content_type)
      @document = Msword.new(document_params)
    elsif Msexcel.content_types.include?(document_params[:data].content_type)
      @document = Msexcel.new(document_params)
    elsif Image.content_types.include?(document_params[:data].content_type)
      @document = Image.new(document_params)
    elsif Video.content_types.include?(document_params[:data].content_type)
      @document = Video.new(document_params)
    else
      @document = Document.new(document_params)
    end

    @document.created_by = session[:user_id]

    respond_to do |format|
      if @document.save
        format.html { render text: "<script>window.top.location.href ='#{document_url(@document)}';</script>" }
        format.json { render action: 'show', status: :created, location: @document }
      else
        format.html { render action: 'new', status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { render text: "<script>window.top.location.href ='#{document_url(@document)}';</script>" }
        format.json { head :no_content }
      else
        # format.html { render action: 'edit'}
        format.html { render text: "<script>window.top.location.href ='#{document_url(@document)}';</script>"}
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    project = @document.project
    @document.destroy
    respond_to do |format|
      format.html { redirect_to project }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:name, :project_id, :data, :scene_number)
    end
end


