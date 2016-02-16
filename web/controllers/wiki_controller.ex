defmodule Pwiki.WikiController do
  use Pwiki.Web, :controller

  alias Pwiki.WikiPage

  # def index(conn, _params) do
  #   wiki_pages = Repo.all(WikiPage)
  #   render(conn, "index.html", wiki_pages: wiki_pages)
  # end
  #

  def index(conn, _params) do
    redirect conn, to: wiki_path(conn, :show, "index")
  end

  def new(conn, %{"page_title" => title}) do
    changeset = WikiPage.changeset(%WikiPage{title: title})
    render(conn, "new.html", changeset: changeset, title: title)
  end
  #
  def create(conn, %{"page_title" => title, "wiki_page" => wiki_page_params}) do
    changeset = WikiPage.changeset(%WikiPage{title: title}, wiki_page_params)

    case Repo.insert(changeset) do
      {:ok, _wiki_page} ->
        conn
        |> put_flash(:info, "Wiki page created successfully.")
        |> redirect(to: wiki_path(conn, :show, title))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"page_title" => title}) do
    case Repo.get_by(WikiPage, title: title) do
      :nil ->
        redirect conn, to: wiki_path(conn, :new, title)
      wiki_page ->
        # wiki_page.body = linkize(wiki_page.body)
        p = %WikiPage{title: title, body: linkize(conn, wiki_page.body)}
        render(conn, "show.html", wiki_page: p)
    end
  end

  def edit(conn, %{"page_title" => title}) do
    wiki_page = Repo.get_by(WikiPage, title: title)
    changeset = WikiPage.changeset(wiki_page)
    render(conn, "edit.html", wiki_page: wiki_page, changeset: changeset, title: title)
  end

  def update(conn, %{"page_title" => title, "wiki_page" => wiki_page_params}) do
    wiki_page = Repo.get_by(WikiPage, title: title)
    changeset = WikiPage.changeset(wiki_page, wiki_page_params)

    case Repo.update(changeset) do
      {:ok, _wiki_page} ->
        conn
        |> put_flash(:info, "Wiki page updated successfully.")
        |> redirect(to: wiki_path(conn, :show, title))
      {:error, changeset} ->
        render(conn, "edit.html", wiki_page: wiki_page, changeset: changeset)
    end
  end

  def linkize(conn, body) do
    String.split(body, "\n")
    |> Enum.map(&(linkize_line(conn, &1)))
    |> Enum.join("\n")
    |> Earmark.to_html
  end

  def linkize_line(conn, line) do
    String.split(line)
    |> Enum.map(&(linkize_token(conn, &1)))
    |> Enum.join(" ")
  end

  def linkize_token(conn, token) do
    # we assume it's a link if it starts with A-Z
    case token =~ ~r/^[A-Z]/ do
      true ->
        path = wiki_path(conn, :show, token)
        "[#{token}](#{path})"
      false -> case token =~ ~r/^\![A-Z]/ do
        true -> String.slice(token, 1, :infinity)
        false -> token
      end
    end
  end
end
