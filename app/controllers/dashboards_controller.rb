class DashboardsController < ApplicationController

  def index
    @leads = Lead.all.order(created_at: :desc).limit(15)
    @vehicles = Vehicle.all.order(created_at: :desc).limit(15)
  end
end
