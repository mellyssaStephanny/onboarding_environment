defmodule ApiProductsWeb.Router do
  use ApiProductsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ApiProductsWeb do
    pipe_through :api
    resources "/products", ProductController, only: [:index, :create, :update, :show, :delete]
  end
end
