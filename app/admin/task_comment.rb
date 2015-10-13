  ActiveAdmin.register Comment, :as => 'TaskComments' do
  	menu priority: 3
  	permit_params :task_id, :body, :commentable_type
  end