defmodule UshortenWeb.UrlJSON do
  alias Ushorten.Urls.Url

  @doc """
  Renders a list of urls.
  """
  def index(%{urls: urls}) do
    %{data: for(url <- urls, do: data(url))}
  end

  @doc """
  Renders a single url.
  """
  def show(%{url: url}) do
    %{data: data(url)}
  end

  defp data(%Url{} = url) do
    %{
      id: url.id,
      link: url.link,
      short: Base62.encode(url.id),
      hash: url.hash
    }
  end

  @doc """
  Renders not found error.
  """
  def not_found(_) do
    %{error: "not found"}
  end

  @doc """
  Renders invalid captcha error.
  """
  def invalid_captcha(_) do
    %{error: "invalid captcha"}
  end
end


# SELECT ZASSET.ZFILENAME, ZCLOUDMASTER.ZORIGINALFILENAME, ZASSET.ZDATECREATED FROM ZCLOUDMASTER
# INNER JOIN ZASSET ON ZCLOUDMASTER.Z_PK = ZASSET.ZMASTER ORDER BY ZASSET.ZDATECREATED DESC LIMIT 30, 30;
