class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @items = Item.all
    @locations = Location.location_tree
  end
  
  def show
  end

  def new
    @item = Item.new
    @item.id ? @new_record = @item.id :  @new_record = true
    parent_id = Item.find(params[:item_id]).location.id if params[:item_id]
		@item.build_location(parent_id: parent_id)
    #for ajax loading, can set initial state with 'data' ie root, empty, id, 
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    respond_to do |format|
      if @item.save
        format.html { redirect_to items_path}
      else
        format.html { render action: 'new'}
      end
    end
  end

  def update
  end

  def destroy
  end
  
	def move_item
		if params[:node_moved] then
			Item.move_location(params[:node_moved],params[:target_node])
		end
		@locations = Location.location_tree
		render action: 'index'
	end 
   
  private
  
  def set_item
    @item = Item.find(params[:id])
  end
  
  def item_params
    params.require(:item).permit( :name, :code,
    location_attributes: [ :id, :parent_id, :is_location, :item_id ] )
  end
end
