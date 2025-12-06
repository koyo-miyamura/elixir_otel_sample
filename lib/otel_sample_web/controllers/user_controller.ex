defmodule OtelSampleWeb.UserController do
  use OtelSampleWeb, :controller

  require OpenTelemetry.Tracer, as: Tracer

  alias OtelSample.Accounts
  alias OtelSample.Accounts.User

  action_fallback OtelSampleWeb.FallbackController

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    Tracer.with_span "UserController.create" do
      Tracer.set_attributes([{"controller.action", "create"}, {"user.name", user_params["name"]}])

      result =
        Tracer.with_span "Accounts.create_user" do
          Tracer.set_attributes([{"attrs.name", user_params["name"]}])
          Accounts.create_user(user_params)
        end

      with {:ok, %User{} = user} <- result do
        Tracer.set_attributes([{"user.id", user.id}, {"result", "success"}])

        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> render(:show, user: user)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
