defmodule GrimoireWeb.ClubLive.Index do
  use GrimoireWeb, :live_view

  alias Grimoire.Clubs

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Clubs
        <:actions>
          <.button variant="primary" navigate={~p"/clubs/new"}>
            <.icon name="hero-plus" /> New Club
          </.button>
        </:actions>
      </.header>

      <.table
        id="clubs"
        rows={@streams.clubs}
        row_click={fn {_id, club} -> JS.navigate(~p"/clubs/#{club}") end}
      >
        <:col :let={{_id, club}} label="Name">{club.name}</:col>
        <:action :let={{_id, club}}>
          <div class="sr-only">
            <.link navigate={~p"/clubs/#{club}"}>Show</.link>
          </div>
          <.link navigate={~p"/clubs/#{club}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, club}}>
          <.link
            phx-click={JS.push("delete", value: %{id: club.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Clubs")
     |> stream(:clubs, list_clubs())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    club = Clubs.get_club!(id)
    {:ok, _} = Clubs.delete_club(club)

    {:noreply, stream_delete(socket, :clubs, club)}
  end

  defp list_clubs() do
    Clubs.list_clubs()
  end
end
