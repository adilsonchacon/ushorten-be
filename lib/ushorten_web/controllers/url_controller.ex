defmodule UshortenWeb.UrlController do
  use UshortenWeb, :controller

  alias Ushorten.Urls
  alias Ushorten.Urls.Url

  @google_client Application.compile_env(:ushorten, :google_client, GoogleClient)

  action_fallback UshortenWeb.FallbackController

  def create(conn, %{"url" => url_params}) do
    with :ok <- check_google_recaptacha(conn, url_params["g-recaptcha-token"]),
         {:ok, %Url{} = url} <- Urls.find_or_create_by_link(url_params["link"])
    do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/urls/#{url}")
      |> render(:show, url: url)
    end
  end

  defp check_google_recaptacha(conn, token) do
    case @google_client.recaptcha_verify(token) do
      :ok ->
        :ok
      _ ->
        conn
        |> put_status(:bad_request)
        |> render(:invalid_captcha)
    end
  end

  def show(conn, %{"id" => id}) do
    try do
      url = Urls.get_url!(id)
      render(conn, :show, url: url)
    rescue
      _ ->
        conn
        |> put_status(:not_found)
        |> render(:not_found)
    end
  end
end
