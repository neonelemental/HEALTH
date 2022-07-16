Rails.application.routes.draw do
  mount Health::Engine => "/health"
end
