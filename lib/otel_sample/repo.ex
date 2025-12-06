defmodule OtelSample.Repo do
  use Ecto.Repo,
    otp_app: :otel_sample,
    adapter: Ecto.Adapters.Postgres
end
