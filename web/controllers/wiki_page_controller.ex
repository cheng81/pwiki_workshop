defmodule Pwiki.WikiPageController do
  use Pwiki.Web, :controller

  alias Pwiki.WikiPage

  plug :scrub_params, "wiki_page" when action in [:create, :update]

  def index(conn, _params) do
    wiki_pages = Repo.all(WikiPage)
    render(conn, "index.html", wiki_pages: wiki_pages)
  end

  def new(conn, _params) do
    changeset = WikiPage.changeset(%WikiPage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"wiki_page" => wiki_page_params}) do
    changeset = WikiPage.changeset(%WikiPage{}, wiki_page_params)

    case Repo.insert(changeset) do
      {:ok, _wiki_page} ->
        conn
        |> put_flash(:info, "Wiki page created successfully.")
        |> redirect(to: wiki_page_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    wiki_page = Repo.get!(WikiPage, id)
    render(conn, "show.html", wiki_page: wiki_page)
  end

  def edit(conn, %{"id" => id}) do
    wiki_page = Repo.get!(WikiPage, id)
    changeset = WikiPage.changeset(wiki_page)
    render(conn, "edit.html", wiki_page: wiki_page, changeset: changeset)
  end

  def update(conn, %{"id" => id, "wiki_page" => wiki_page_params}) do
    wiki_page = Repo.get!(WikiPage, id)
    changeset = WikiPage.changeset(wiki_page, wiki_page_params)

    case Repo.update(changeset) do
      {:ok, wiki_page} ->
        conn
        |> put_flash(:info, "Wiki page updated successfully.")
        |> redirect(to: wiki_page_path(conn, :show, wiki_page))
      {:error, changeset} ->
        render(conn, "edit.html", wiki_page: wiki_page, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    wiki_page = Repo.get!(WikiPage, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(wiki_page)

    conn
    |> put_flash(:info, "Wiki page deleted successfully.")
    |> redirect(to: wiki_page_path(conn, :index))
  end
end
