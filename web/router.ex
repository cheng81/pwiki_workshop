defmodule Pwiki.Router do
  use Pwiki.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pwiki do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/wiki_pages", WikiPageController
    get "/w/:page_title/new", WikiController, :new
    post "/w/:page_title/create", WikiController, :create
    put "/w/:page_title", WikiController, :update
    get "/w/:page_title/edit", WikiController, :edit
    get "/w/:page_title", WikiController, :show
    # put "/w/:page_title", WikiController :put
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pwiki do
  #   pipe_through :api
  # end
end
