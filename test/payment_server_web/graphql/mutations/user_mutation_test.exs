defmodule PaymentServerWeb.Graphql.Mutations.UserMutationTest do
  use PaymentServerWeb.ConnCase, async: true
  use PaymentServerWeb.RepoCase

  @create_user_mutation """
  mutation ($email: String!, $name: String!) {
    createUser(email: $email, name: $name) {
      email
      name
    }
  }
  """

  test "it should create a new User with valid attributes", %{conn: _conn} do
    user_input = %{
      "name" => "user-1",
      "email" => "user-1@email.com"
    }

    {:ok, ref} =
      Absinthe.run(@create_user_mutation, PaymentServerWeb.Schema, variables: user_input)

    expected = %{
      data: %{
        "createUser" => get_in(ref, [:data, "createUser"])
      }
    }

    assert ref == expected
  end
end
