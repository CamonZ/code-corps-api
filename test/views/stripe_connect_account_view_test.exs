defmodule CodeCorps.StripeConnectAccountViewTest do
  use CodeCorps.ConnCase, async: true

  import Phoenix.View, only: [render: 3]

  test "renders all attributes and relationships properly" do
    organization = insert(:organization)
    account = insert(:stripe_connect_account,
      organization: organization,
      verification_disabled_reason: "fields_needed",
      verification_fields_needed: ["legal_entity.first_name", "legal_entity.last_name"]
    )

    rendered_json = render(CodeCorps.StripeConnectAccountView, "show.json-api", data: account)

    expected_json = %{
      "data" => %{
        "attributes" => %{
          "business-name" => account.business_name,
          "business-url" => account.business_url,
          "can-accept-donations" => true,
          "charges-enabled" => account.charges_enabled,
          "country" => account.country,
          "default-currency" => account.default_currency,
          "details-submitted" => account.details_submitted,
          "display-name" => account.display_name,
          "email" => account.email,
          "id-from-stripe" => account.id_from_stripe,
          "inserted-at" => account.inserted_at,
          "managed" => account.managed,
          "support-email" => account.support_email,
          "support-phone" => account.support_phone,
          "support-url" => account.support_url,
          "transfers-enabled" => account.transfers_enabled,
          "updated-at" => account.updated_at,
          "verification-disabled-reason" => account.verification_disabled_reason,
          "verification-due-by" => account.verification_due_by,
          "verification-fields-needed" => account.verification_fields_needed
        },
        "id" => account.id |> Integer.to_string,
        "relationships" => %{
          "organization" => %{
            "data" => %{"id" => organization.id |> Integer.to_string, "type" => "organization"}
          }
        },
        "type" => "stripe-connect-account",
      },
      "jsonapi" => %{
        "version" => "1.0"
      }
    }

    assert rendered_json == expected_json
  end

  test "renders can-accept-donations as true in prod when charges-enabled is true" do
    Application.put_env(:code_corps, :stripe_env, :prod)

    organization = insert(:organization)
    account = insert(:stripe_connect_account, organization: organization, charges_enabled: true)

    rendered_json = render(CodeCorps.StripeConnectAccountView, "show.json-api", data: account)
    assert rendered_json["data"]["attributes"]["can-accept-donations"] == true
    assert rendered_json["data"]["attributes"]["charges-enabled"] == true

    Application.put_env(:code_corps, :stripe_env, :test)
  end

  test "renders can-accept-donations as false in prod when charges-enabled is false" do
    Application.put_env(:code_corps, :stripe_env, :prod)

    organization = insert(:organization)
    account = insert(:stripe_connect_account, organization: organization, charges_enabled: false)

    rendered_json = render(CodeCorps.StripeConnectAccountView, "show.json-api", data: account)
    assert rendered_json["data"]["attributes"]["can-accept-donations"] == false
    assert rendered_json["data"]["attributes"]["charges-enabled"] == false

    Application.put_env(:code_corps, :stripe_env, :test)
  end

  test "renders can-accept-donations as true in test when charges-enabled is false" do
    organization = insert(:organization)
    account = insert(:stripe_connect_account, organization: organization, charges_enabled: false)

    rendered_json = render(CodeCorps.StripeConnectAccountView, "show.json-api", data: account)
    assert rendered_json["data"]["attributes"]["can-accept-donations"] == true
    assert rendered_json["data"]["attributes"]["charges-enabled"] == false
  end
end
