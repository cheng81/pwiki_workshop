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
  end

  scope "/weeky", Pwiki do
    pipe_through :browser # Use the default browser stack

    get "/", WikiController, :index

    get "/:page_title", WikiController, :show
    put "/:page_title", WikiController, :update

    get "/:page_title/new", WikiController, :new
    post "/:page_title/create", WikiController, :create
    get "/:page_title/edit", WikiController, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pwiki do
  #   pipe_through :api
  # end
end
