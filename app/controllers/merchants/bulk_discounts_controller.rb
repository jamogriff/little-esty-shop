class Merchants::BulkDiscountsController < ApplicationController
  rescue_from ApiConnectionError, with: :connection_error

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @calendar = CalendarService.next_three_holidays
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.new(discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(id: params[:merchant_id]) 
    else
      flash.now[:warning] = "Whoops! #{error_message(discount.errors)}"
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
    if @discount.update(discount_params)
      redirect_to merchant_bulk_discount_path(merchant_id: params[:merchant_id], id: params[:id]) 
    else
      flash.now[:warning] = "Whoops! #{error_message(@discount.errors)}"
      render :edit
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.find(params[:id])
    if discount.destroy
      redirect_to merchant_bulk_discounts_path(id: params[:merchant_id]) 
      flash[:notice] = "Discount Successfully Deleted"
    else
      redirect_to merchant_bulk_discounts_path(id: params[:merchant_id]) 
      flash[:notice] = "An error occurred. Please try again."
    end
  end

  
  private

  def discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end

  # This will have to be explored at a later time,
  # Utilizing a serializer will allow to render out the error
  # and bypass making another API connection that will fail
  def connection_error(exception)
    flash[:raise] = "Error: #{exception.message}"
  end
end
