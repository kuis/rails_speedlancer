$(document).on('click', '.remove_fields', function(event){
  $(this).prev('input[type=hidden]').val('1');
  $(this).parent('.attachment-block').hide();
  event.preventDefault();
});

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}