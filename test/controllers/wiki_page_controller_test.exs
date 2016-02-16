defmodule Pwiki.WikiPageControllerTest do
  use Pwiki.ConnCase

  alias Pwiki.WikiPage
  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, wiki_page_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing wiki pages"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, wiki_page_path(conn, :new)
    assert html_response(conn, 200) =~ "New wiki page"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, wiki_page_path(conn, :create), wiki_page: @valid_attrs
    assert redirected_to(conn) == wiki_page_path(conn, :index)
    assert Repo.get_by(WikiPage, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, wiki_page_path(conn, :create), wiki_page: @invalid_attrs
    assert html_response(conn, 200) =~ "New wiki page"
  end

  test "shows chosen resource", %{conn: conn} do
    wiki_page = Repo.insert! %WikiPage{}
    conn = get conn, wiki_page_path(conn, :show, wiki_page)
    assert html_response(conn, 200) =~ "Show wiki page"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, wiki_page_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    wiki_page = Repo.insert! %WikiPage{}
    conn = get conn, wiki_page_path(conn, :edit, wiki_page)
    assert html_response(conn, 200) =~ "Edit wiki page"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    wiki_page = Repo.insert! %WikiPage{}
    conn = put conn, wiki_page_path(conn, :update, wiki_page), wiki_page: @valid_attrs
    assert redirected_to(conn) == wiki_page_path(conn, :show, wiki_page)
    assert Repo.get_by(WikiPage, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    wiki_page = Repo.insert! %WikiPage{}
    conn = put conn, wiki_page_path(conn, :update, wiki_page), wiki_page: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit wiki page"
  end

  test "deletes chosen resource", %{conn: conn} do
    wiki_page = Repo.insert! %WikiPage{}
    conn = delete conn, wiki_page_path(conn, :delete, wiki_page)
    assert redirected_to(conn) == wiki_page_path(conn, :index)
    refute Repo.get(WikiPage, wiki_page.id)
  end
end
