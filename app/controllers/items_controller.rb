class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @no_item_records = Item.count ? false : true
    set_tree_root
		respond_to do |format|
			format.html
			format.json
		end
  end
  
  def show
  end

  def new
    @item = Item.new
    @item.id ? @new_record = @item.id :  @new_record = true
    parent_id = Item.find(params[:item_id]).location.id if params[:item_id]
		@item.build_location(parent_id: parent_id)
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
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
		if params[:select_parent] == "true" then
      @item_path = @item.parent_item.item_path
    else
      @itemPath = false
    end
		if @item.location.can_be_destroyed
			@item.destroy
			render "destroy.js.erb"
		else
			render status: 400
		end
  end
  
  def breadcrumb
    if params[:open_id] == 'root' then
      @item_path = Location.roots.first.item.item_path
    elsif params[:parent_id] == 'true'
      @item_path = Item.parent_item.item_path
    else
      @item_path = Item.find(params[:open_id]).item_path
    end
    respond_to do |format|
      format.js
    end
  end
  
	def move_item
		if params[:node_moved] then
			Item.move_location(params[:node_moved],params[:target_node])
		end
		@locations = Location.location_tree
		# render: Just need to report success or failure as no need to update jsTree data
	end 
  
  def search
    if params[:query].present? then
      @locations = Location.text_search(params[:query])
      logger.debug(@locations.length)
    else
      set_tree_root
    end
		respond_to do |format|
			format.json
		end
  end
   
  private
	
  def set_tree_root
		# Note: in use in the FM app the root item will be Organisation,
    # therefore will need to change this method.
    if session[:tree_root] then 
		  if params[:open_id].present?
         session[:tree_root] = params[:open_id]
      end
      if params[:root].present? then
        session[:show_organisation] = params[:root] == 'true'
      end
		else
			session[:tree_root] = Location.roots.first.item.id
      session[:show_organisation] = true
		end
		@item = Item.find(session[:tree_root])
    if session[:show_organisation] then
      @locations = @item.location.subtree.location_tree
    else
      @locations = @item.location.descendants.location_tree
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
