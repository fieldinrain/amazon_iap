defmodule AmazonIAPTest do
  use ExUnit.Case
  alias AmazonIAP.RVSResponse
  require AmazonIAP.ErrorStatus, as: ErrorStatus
  doctest AmazonIAP

  setup_all do
    json = %{
      "betaProduct": false,
      "cancelDate": nil,
      "parentProductId": nil,
      "productId": "com.amazon.iapsamplev2.gold_medal",
      "productType": "CONSUMABLE",
      "purchaseDate": 1399070221749,
      "quantity": 1,
      "receiptId": "wE1EG1gsEZI9q9UnI5YoZ2OxeoVKPdR5bvPMqyKQq5Y=:1:11",
      "renewalDate": nil,
      "term": nil,
      "termSku": nil,
      "testTransaction": true
    }
    json_string = Poison.encode!(json)
    struct = %RVSResponse{
      beta_product: false,
      cancel_date: nil,
      parent_product_id: nil,
      product_id: "com.amazon.iapsamplev2.gold_medal",
      product_type: "CONSUMABLE",
      purchase_date: 1399070221749,
      quantity: 1,
      receipt_id: "wE1EG1gsEZI9q9UnI5YoZ2OxeoVKPdR5bvPMqyKQq5Y=:1:11",
      renewal_date: nil,
      term: nil,
      term_sku: nil,
      test_transaction: true
    }
    %{json_string: json_string, struct: struct}
  end

  test "when http request was failed" do
    assert AmazonIAP.parse_response({:error, :error}) == {:error, ErrorStatus.http_request_failed, :error}
  end

  test "parse succeeded response", %{json_string: json_string, struct: struct} do
    response = %HTTPoison.Response{status_code: 200, body: json_string}
    assert AmazonIAP.parse_response({:ok, response}) == {:ok, struct}
  end

  test "parse failed response" do
    response = %HTTPoison.Response{status_code: 400}
    assert AmazonIAP.parse_response({:ok, response}) == {:error, 400}
  end
end
