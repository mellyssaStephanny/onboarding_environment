defmodule ApiProducts.Repo do
  use Ecto.Repo, otp_app: :project_name, adapter: Mongo.Ecto
end
