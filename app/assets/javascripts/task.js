$(function() {
  $('.edit_task, .new_task').submit(function() {
    $(this).addClass("loading")
    custom_push_alert("Uploading files. Please do not refresh or exit page", "notice")
    return true
  });
});

