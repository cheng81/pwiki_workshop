defmodule Pwiki.WikiPageTest do
  use Pwiki.ModelCase

  alias Pwiki.WikiPage

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = WikiPage.changeset(%WikiPage{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = WikiPage.changeset(%WikiPage{}, @invalid_attrs)
    refute changeset.valid?
  end
end
