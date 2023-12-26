defmodule Nested.Child do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :label, :string
    field :value, :string
  end

  @fields ~w(label value)a

  def changeset(child \\ %__MODULE__{}, attrs \\ %{}) do
    child
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end

defmodule Nested.Parent do
  use Ecto.Schema

  alias Nested.Child

  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :description, :string

    embeds_many :children, Child
  end

  @fields ~w(name description)a

  def changeset(parent \\ %__MODULE__{}, attrs \\ %{}) do
    parent
    |> cast(attrs, @fields)
    |> cast_embed(:children)
    |> validate_required(@fields)
  end
end
