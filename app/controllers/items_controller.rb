class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  
  def index
    @items = Item.all
  end
  
  def show
  end

  def new
    @item = Item.new
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
  
  private
  
  def set_item
    @item = Item.find(params[:id])
  end
  
  def item_params
    params.require(:item).permit( :name, :code )
  end
end
