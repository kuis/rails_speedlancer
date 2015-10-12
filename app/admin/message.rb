  ActiveAdmin.register Message do
    menu priority: 3
    permit_params :task_id, :content, :messagable_type
  end