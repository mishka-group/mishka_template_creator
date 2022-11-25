defmodule MishkaTemplateCreator.Repo do
  use Ecto.Repo,
    otp_app: :mishka_template_creator,
    adapter: Ecto.Adapters.Postgres
end
