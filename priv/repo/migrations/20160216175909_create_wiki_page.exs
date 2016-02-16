defmodule Pwiki.Repo.Migrations.CreateWikiPage do
  use Ecto.Migration

  def change do
    create table(:wiki_pages) do
      add :title, :string
      add :body, :string

      timestamps
    end

  end
end
