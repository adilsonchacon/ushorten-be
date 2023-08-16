defmodule UshortenWeb.ShortController do
  use UshortenWeb, :controller

  alias Ushorten.Urls

  action_fallback UshortenWeb.FallbackController

  def short(conn, %{"short" => short}) do
    try do
      url = Urls.get_url!(Base62.decode(short))
      conn
      |> put_status(:moved_permanently)
      |> redirect(external: url.link)
    rescue
      _ ->
        conn
        |> put_status(:not_found)
        |> render(:not_found, layout: false)
    end
  end
end
