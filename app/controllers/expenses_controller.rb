class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show update destroy ]

  #GET
  def index
    @expenses = Expense.all
    render json: @expenses
  end

  #GET
  def show
    render json: @expense
  end

  #POST
  def create
    @expense = Expense.new(expense_params)

    if @expense.save
      render json: @expense, status: :created, location: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  #PATCH/PUT
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # DELETE
  def destroy
    @expense.destroy!
    head :no_content
  end

  private
    def set_expense
      @expense = Expense.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def expense_params
      params.require(:expense).permit(:title, :amount, :date, :category)
    end

    def summary
  totals = Expense.group(:category).sum(:amount)
  grand_total = totals.values.sum

  summary = totals.map do |category, amount|
    {
      category: category,
      amount: amount.to_f,
      percentage: grand_total > 0 ? ((amount / grand_total) * 100).round(1) : 0
    }
  end

  render json: summary
end
end