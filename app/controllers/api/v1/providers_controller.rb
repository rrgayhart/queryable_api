class Api::V1::ProvidersController < ApplicationController
  before_action :validate_params

  def index
    base = query_params.empty? ? Provider.all : Provider.build_query(query_params.to_h)
    @showing = 100
    @page = params[:page] || '1'
    @providers = base.paginate(page: @page, per_page: @showing)
  end

  private

  def validate_params
    params.each do |query|
      check_numeric_query(query)
      check_state_query(query)
    end
  end

  def check_numeric_query(query)
    has_min_max = /^m(in|ax)_(.)*$/ === query
    only_digits = /^\d+$/ === params[query]
    render_error(query) if has_min_max && !only_digits 
  end

  def check_state_query(query)
    is_state_query = query === "state"
    render_error(query) if is_state_query && params[query].length != 2
  end

  def render_error(query)
    render json: { error: "#{query} param invalid" }, status: :bad_request and return
  end

  def query_params
    params.permit(:max_discharges, :min_discharges, :max_average_covered_charges,
      :min_average_covered_charges, :min_average_medicare_payments, :max_average_medicare_payments,
      :state)
  end
end