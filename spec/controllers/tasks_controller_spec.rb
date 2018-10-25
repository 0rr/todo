require 'rails_helper'

RSpec.describe TasksController, type: :controller do
	describe "tasks#index" do
		it "should list the tasks in the database" do
			#add tasks
			task1 = FactoryBot.create(:task)
			task2 = FactoryBot.create(:task)

			#make change to task1
			task1.update_attributes(title: "Something else")

			#trigger the tasks#index action
			get :index

			#make sure the HTTP request performs successfully
			expect(response).to have_http_status :success

			#access the actual reponse from the app using the instance vairable @response

			response_value = ActiveSupport::JSON.decode(@response.body)
			expect(response_value.count).to eq(2)

			#remember, response+value is an JSON array of the tasks
			response_ids = []
			response_value.each do |task|
				response_ids << task["id"]
			end

			expect(response_ids).to eq([task1.id, task2.id])
		end
	end

	describe "tasks#update" do
		it "should allow tasks to be marked as done" do
			task = FactoryBot.create(:task, done: false)
			put :update, params: {id: task.id, task: {done: true } }
			expect(response).to have_http_status(:success)
			task.reload
			expect(task.done).to eq(true)
		end
	end

	describe "tasks#create" do
		it "should allow new tasks to be created" do
			post :create, params: {task: {title: "Fix things"}}						# create a HTTP POST request to the TasksController #create action, with a task, with a title "Fix things"
			expect(response).to have_http_status(:success)									# expect the HTTP response to be successful
			response_value = ActiveSupport::JSON.decode(@response.body)		# parse the response as JSON
			expect(response_value['title']).to eq("Fix things")						# ensure the title has been populated
			expect(Task.last.title).to eq("Fix things")										# make sure the record is stored in the database
		end
	end
end
