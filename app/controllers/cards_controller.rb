class CardsController < ApplicationController
  require "payjp"
  before_action :set_card

  def new
    card = Card.where(user_id: current_user.id)
    redirect_to card_path(@card.user_id) if card.exists?
  end


  def create  #payjpとCardのデータベース作成
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    if params['payjp-token'].blank?
      redirect_to action: "new"
    else
      customer = Payjp::Customer.create(
      description: '登録テスト', 
      email: current_user.email, 
      card: params['payjp-token'],
      metadata: {user_id: current_user.id}
      ) 
      @card = Card.new(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
      if @card.save
        redirect_to card_path(@card.user_id)
      else
        redirect_to action: "create"
      end
    end
  end


  def show  #Cardのデータをpayjpに送り情報取り出す
    card = Card.where(user_id: current_user.id).first
    if card.blank?
      redirect_to action: "new" 
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = customer.cards.retrieve(card.card_id)
    end  
  end


  def edit
    
  end
  

  def update
    Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
    customer = Payjp::Customer.create(
    description: '登録テスト', 
    email: current_user.email, 
    card: params['payjp-token'],
    metadata: {user_id: current_user.id}
    ) 
    @card = Card.update(user_id: current_user.id, customer_id: customer.id, card_id: customer.default_card)
    redirect_to action: "new"
  end
  

  def destroy
    card = Card.where(user_id: current_user.id).first
    if card.blank?
    else
      Payjp.api_key = ENV["PAYJP_PRIVATE_KEY"]
      customer = Payjp::Customer.retrieve(card.customer_id)
      customer.delete
      card.delete
    end
      redirect_to action: "new"
  end


  private

  def set_card
    @card = Card.where(user_id: current_user.id).first if Card.where(user_id: current_user.id).present?
  end

end
