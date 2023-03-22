require 'rails_helper'

RSpec.describe "Api::Fibonaccis", type: :request do
  describe "GET /api/fibonaccis" do
 
    before do 
      create(:computation)
    end

    it 'should have content_type as json and https status as 200' do
      get "/api/fibonaccis"
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'should have response with four attributes: value, result, runtime and created_at' do  
      get "/api/fibonaccis"
      expect(JSON.parse(response.body).first.keys).to eql ["value", "result", "runtime", "created_at"]
    end

    it 'should have result attribute as 55 for value 10' do  
      get "/api/fibonaccis"
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.first["value"]).to eq 10
      expect(parsed_response.first["result"]).to eq 55
    end

    context "More than 10 records in DB" do 

      before do 
        11.times { create(:computation) } 
      end  

      it 'should return only 10 records if db has more than 10 records' do  
        get "/api/fibonaccis"
        expect(JSON.parse(response.body).count).to eq 10
      end

    end

    context "less than 10 records in DB" do 

      before do 
        5.times { create(:computation) }     
      end  

      it "should return less than 10 records if db doesn't have10 records" do  
        get "/api/fibonaccis"
        expect(JSON.parse(response.body).count).to be < 10
      end

    end

  end

  describe "POST /api/fibonaccis" do
    context "Success" do 
      before do 
        @params = {n: 15}
      end

      it 'should have content_type as json and https status as 200' do
        post "/api/fibonaccis", params: @params
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'should have response with three attributes: value, result, runtime' do  
        post "/api/fibonaccis", params: @params
        expect(JSON.parse(response.body).keys).to eql ["value", "result", "runtime"]
      end

      it 'should create a new computation record in the database' do 
        expect { post "/api/fibonaccis", params: @params }.to change { Computation.count }.by(1)
      end

    end

    context "Failure" do 
      before do 
        @params = {}
      end

      it 'should have content_type as json and https status as 200' do
        post "/api/fibonaccis", params: @params
        expect(response).to have_http_status(400)
        expect(response.content_type).to eq('application/json; charset=utf-8')
      end

      it 'should have response with three attributes: value, result, runtime' do  
        post "/api/fibonaccis", params: @params
        expect(JSON.parse(response.body).keys).to eql ["error", "status"]
      end
    end
       

  end
end
