function add_watcher_to_task(seller_id, task_id) {
  url = "/tasks/" + task_id + "/add_watcher"
  $.ajax({ url: url, type: 'PUT', data: { seller_id: seller_id}});
}

function add_watcher_from_task (seller_id, task_id) {
 url = "/tasks/" + task_id + "/remove_watcher"
  $.ajax({ url: url, type: 'PUT', data: { seller_id: seller_id}});
}
