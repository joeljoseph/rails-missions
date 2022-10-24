module ResponseHelper
  let(:json_response) { JSON.parse(response.body) }
end