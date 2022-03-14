defmodule ApiProductsWeb.Router do
  use ApiProductsWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/products", ApiProductsWeb do
    pipe_through(:api)
    resources("/", ProductController, only: [:index, :create])
    put("/:sku", ProductController, :update)
    delete("/:sku", ProductController, :delete)
    get("/:sku", ProductController, :show)
  end
end
