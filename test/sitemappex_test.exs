defmodule SitemappexTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "test/fixture/custom_cassettes")
    :ok
  end

  @tag timeout: 1000

  test "with valid response" do
    use_cassette "response_mocking", custom: true do
      result = Sitemappex.map_links("http://example.com")
      assert 3 = length(result)
    end
  end
end
