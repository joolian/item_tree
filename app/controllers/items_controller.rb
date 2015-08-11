class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @no_item_records = Item.count ? false : true
    #create_data 
    set_tree_root
    get_locations
		respond_to do |format|
			format.html
			format.json
		end
  end
  
  def show
  end

  def new
    @item = Item.new
    parent_id = Item.find(params[:item_id]).location.id if params[:item_id]
    @item.build_location(parent_id: parent_id)
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render action: 'new'
    end
  end

  def update
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
		#if @item.location.can_be_destroyed
    if @item.can_be_destroyed     
      @item_path = params[:select_parent] == "true" ? @item.parent_item.item_path : false
			@item.destroy
			render "destroy.js.erb"
		else
			render status: 400
		end
  end
  
  def breadcrumb
    # TODO a thing has no children, therefore either link to view item, or do nothing
    # TODO Change js code to allow use of fontawesome and similar
    # TODO Change js code to enable drag and drop
    # TODO Change js code to allow context menu
    @item_path = Item.find(params[:root_id]).item_path
    respond_to do |format|
      format.js
    end
  end
  
	def move_item
		if params[:node_moved]
			if Item.move_location(params[:node_moved],params[:target_node])
        render "move_item"
      else
        render status: 400
      end
		end
		#@locations = Location.location_tree
	end 
  
  def search
    @locations = Item.text_search(params[:query])      
		respond_to do |format|
			format.json
		end
  end
  
  def children
    @locations = Item.find(params[:id]).children
    respond_to do |format|
      format.json {render 'index'}
    end
  end
  
  def create_data
    # TODO this is crap, fix it
    Item.destroy_all
    item = Item.new
    item.build_location()
    item.location.is_location = true
    item.name = "Organisation"
    item.code = "O1"
    item.save
    root_id = item.location.id
    for i in 1..100 do
      @item = Item.new
      @item.name = i
      @item.code = i
      @item.build_location(parent_id: root_id)
      @item.location.is_location = true
      @item.save
      parent_id  = @item.location.id
      for r in 1..10 do
        inner_item = Item.new
        inner_item.name = @item.name + "_" + r.to_s
        inner_item.code = @item.name + "_" + r.to_s
        inner_item.build_location(parent_id: parent_id)
        inner_item.save        
      end
    end
  end
   
  private
	
  def set_tree_root
		# Note: in use in the FM app the root item will be Organisation,
    # therefore will need to change this method.
    if session[:tree_root]
		  if params[:root_id].present?
         session[:tree_root] = params[:root_id]
      end
      if params[:show_root].present?
        session[:show_root] = params[:show_root] == 'true'
      end
		else
			session[:tree_root] = Item.root.id   
      session[:show_root] = true
		end
  end
		
  def get_locations  
    @item = Item.find(session[:tree_root])
    if session[:show_root]
      @locations = []
      @locations << @item.location
    else
      @locations = @item.children
    end
		@item_path = @item.item_path
	end
    
  def set_item
    @item = Item.find(params[:id])
  end
  
  def item_params
    params.require(:item).permit( :name, :code,
    location_attributes: [ :id, :parent_id, :is_location, :item_id ] )
  end
end
