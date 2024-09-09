class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]
  ITEMS_PER_PAGE = 5

  # GET /items
  # GET /items.json
  def index
    # Start by getting all the items
    @items = Item.all
    @items = Item.filter_by_store_id(params[:store_id]) if params[:store_id].present?
  
    # Apply filtering if the filter parameter is present
    @items = @items.filter_by_starts_with(params[:starts_with]) if params[:starts_with].present? 
  
    # Now apply pagination to the filtered results
    @page = params.fetch(:page, 0).to_i
    @items = @items.offset(@page * ITEMS_PER_PAGE).limit(ITEMS_PER_PAGE)
    
    render json: @items
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    if @item.save
      render :show, status: :created, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    if @item.update(item_params)
      render :show, status: :ok, location: @item
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :price, :description, :store_id)
    end
end
