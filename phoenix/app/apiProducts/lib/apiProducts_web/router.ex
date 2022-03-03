defmodule ApiProductsWeb.Router do
  use ApiProductsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ApiProductsWeb do
    pipe_through :api
    resources "/products", ProductController, except: [:new, :edit]
  end
end
