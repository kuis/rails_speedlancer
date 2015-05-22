//\\\\\
//Document ready functions
//\\\\\

$(document).ready(ready); //For DOM Ready
$(document).on("ready page:load", ready); //For Turbolinks DOM Ready



//\\\\\
//AJAX COMPLETE
//\\\\\

$(document).ajaxComplete(function(){
	setTimeout(function(){$('.notice, .alert').css('right','-500px');}, 5000);
});


//\\\\\
// Add all recurring functions code in the ready function
//\\\\\

function ready(){
	$('.tasktabs span').on('click', function(){
		$('.tab-box').addClass('hidden');
		$('.tasktabs span').removeClass('activetab');
		$('.' + $(this).attr('data-class') + 'box').removeClass('hidden');
		$(this).addClass('activetab');
	});
	setTimeout(function(){$('.notice, .alert').css('right','-500px');}, 5000);
}

function creditsformtoggle(){
	$('.addform').toggleClass('showform');
	$('.addcredit').toggleClass('active');
}

function custom_push_alert(alert_message, notice_or_alert){
 if ($('.alert-box').length > 0){
   $('.alert-box').remove();
 }
 $('body').append("<div class=" + notice_or_alert + ">" + alert_message + "</div>");
}


function readonly_stars( element_id ,rating_value){
  $("#" + element_id).rateYo({
    rating: rating_value,
    starWidth: "28px",
    readOnly: true
  });
}


function showmodal(){
	var modal = document.querySelector('.modalwrap');
	modal.classList.remove('invisible');
}

function hidemodal(){
	var modal = document.querySelector('.modalwrap');
	modal.classList.add('invisible');
}

function removemodal(){
	var modal = document.querySelector('.modalwrap');
	modal.classList.add('invisible');
	setTimeout(function(){modal.remove()}, 800);
}

function taskModal(event){
	$('#modal').remove();
	var modallink = $(event.target).attr('data');
	$('body').append("<div id='modal'><div class='modalwrap invisible'><div class='modal'><h2 class='formtitle'>Accept Task</h2><span class='closemodal' onclick='removemodal()''>X</span><ul class='modallist'><li>You will get 4 Hours to complete the task.</li><li>Make sure you have gone through the task details and attachments.</li><li>Make sure you have read the comments and asked questions in case you have any.</li></ul><a class='button green icon-btn' href='" + modallink + "'>Accept Task</a></div>");
	setTimeout(showmodal, 100);
}

function parseDate(date_string){
  var regular_expression = /(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})/;
  var date_atay = regular_expression.exec(date_string); 
  var formatted_date = new Date(
    (+date_atay[1]),
    (+date_atay[2])-1, // Careful, month starts at 0!
    (+date_atay[3]),
    (+date_atay[4]),
    (+date_atay[5]),
    (+date_atay[6])
	);
  return formatted_date;
}