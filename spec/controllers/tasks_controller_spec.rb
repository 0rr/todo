require 'rails_helper'

RSpec.describe TasksController, type: :controller do
	describe "tasks#index" do
		it "should list the tasks in the database" do
			#add tasks
			task1 = FactoryBot.create(:task)
			task2 = FactoryBot.create(:task)

			#trigger the tasks#index action
			get :index

			#make sure the HTTP request performs successfully
			expect(response).to have_http_status :success

			#access the actual reponse from the app using the instance vairable @response
			response_value = ActiveSupport::JSON.decode(@response.body)
			expect(response_value.count).to eq(2)
		end
	end
end
