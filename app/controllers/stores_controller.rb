class StoresController < ApplicationController
  before_action :set_store, only: %i[ show update destroy ]
  STORES_PER_PAGE = 2
  # GET /stores
  def index
    @page = params.fetch(:page, 0).to_i
    @stores = Store.offset(@page * STORES_PER_PAGE).limit(STORES_PER_PAGE)

    render json: @stores
  end

  # GET /stores/1
  def show
    render json: @store
  end

  # POST /stores
  def create
    @store = Store.new(store_params)

    if @store.save
      NewStoreNotificationJob.perform_later(@store.id)
      render json: @store, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stores/1
  def update
    if @store.update(store_params)
      render json: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stores/1
  def destroy
    @store.destroy!
  end

  def item_count
    @store = Store.find(params[:id])
    render json: {
      store: @store, item_count: @store.items.count
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:name, :description, :address)
    end
end
