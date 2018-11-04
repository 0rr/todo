	$(function(){
		//the taskhtml methos takes in a JS representation of the task and pproduces an HTML representation using <li> tags
		function taskHtml(task){
			var checkedStatus = task.done ? "checked" : "";
			var liElement = '<li><div class="view"><input class="toggle" type="checkbox"' + 
			"data-id= '" + task.id + "' " +
			checkedStatus + 
			'><label>' +
			task.title +
			'</label></div></li>';
			return liElement;
		}


		//toggleTask takes in an HTML representation of an event that fires from an HTML representation of the toggle checkbox,
		//and performs an API request to toggle the value of the 'done' field
		function toggleTask(e){
			var itemId = $(e.target).data("id");
			var doneValue = Boolean($(e.target).is(':checked'));

				$.post("/tasks/" + itemId, {
					_method: "PUT",
					task: {
						done: doneValue
					}
				});
		}


		$.get("/tasks").success( function ( data ){
			var htmlString = "";

			$.each(data, function(index, task) {
				htmlString += taskHtml(task);
			});

			var ulTodos = $('.todo-list');
			ulTodos.html(htmlString);

			//When an event is fired (triggered), jQuery generally passes the event data (a JavaScript representation of the DOM element that the event is firing for) in a callback
			$('.toggle').change(toggleTask);

		});


		$('#new-form').submit(function(event){
			event.preventDefault();
			var textbox = $('.new-todo');
			var payload = {
				task: {
					title: textbox.val() //build a variable that holds the task name entered in the form. This paylaod will be submitted to /tasks via HTTP POST request
				}
			};

			$.post("/tasks", payload).success(function(data){
				// console.log("Successful HTTP Request.");
				// console.log(data);
				var htmlString = taskHtml(data);
				// console.log(htmlString);
				var ulTodos = $('.todo-list');
				ulTodos.append(htmlString);
				$('.toggle').click(toggleTask);
				$('.new-todo').val('');
			});
		});


	});

