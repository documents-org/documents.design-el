defmodule DocumentsDesign.Repo do
  use Ecto.Repo,
    otp_app: :documents_design,
    adapter: Ecto.Adapters.Postgres
end
