defmodule NestedWeb.HomeLive do
  use NestedWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.simple_form for={@form} phx-change="validate" phx-submit="submit">
      <.input type="text" label="Name" placeholder="Name" field={@form[:name]} />
      <.input type="text" label="Description" placeholder="Description" field={@form[:description]} />

      <h2 class="text-lg font-semibold">Children</h2>
      <.button type="button" phx-click="add-child">Add Child</.button>
      <.inputs_for :let={child} field={@form[:children]}>
        <.input type="text" field={child[:label]} label="Label" placeholder="Label" />
        <.input type="text" field={child[:value]} label="Value" placeholder="Value" />
        <.button type="button" phx-click="remove-child" phx-value-child-id={child[:id].value}>Remove Child</.button>
      </.inputs_for>

      <.button type="submit">Submit</.button>
    </.simple_form>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:form, parent_form())

    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("submit", params, socket) do
    IO.inspect params
    {:noreply, socket}
  end

  def handle_event("validate", params, socket) do
    parent = socket.assigns.form.data
    form = to_form(Nested.Parent.changeset(parent, params))
    socket = assign(socket, :form, form)
    {:noreply, socket}
  end

  def handle_event("remove-child", params, socket) do
    %{"child-id" => child_id} = params
    parent = socket.assigns.form.data
    child_to_remove = Enum.find(parent.children, & &1.id == child_id)
    new_children = List.delete(parent.children, child_to_remove)
    parent = %{parent | children: new_children}
    form = parent_form(parent)
    socket = assign(socket, :form, form)

    {:noreply, socket}
  end

  def handle_event("add-child", _params, socket) do
    parent = socket.assigns.form.data
    parent = %{parent | children: parent.children ++ [%Nested.Child{id: "child#{System.unique_integer()}"}]}
    form = parent_form(parent)

    socket = assign(socket, :form, form)

    {:noreply, socket}
  end

  defp parent_form(parent \\ %Nested.Parent{}) do
    parent
    |> Nested.Parent.changeset()
    |> to_form()
  end
end
