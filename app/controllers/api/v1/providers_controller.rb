class Api::V1::ProvidersController < ApplicationController
  def index
    @providers = Provider.limit(10)
  end
end