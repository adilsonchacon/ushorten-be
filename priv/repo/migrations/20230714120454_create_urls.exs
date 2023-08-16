defmodule Ushorten.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :link, :string, size: 2083
      add :hash, :string, size: 100

      timestamps()
    end

    create unique_index(:urls, [:hash])
  end
end
