// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require jquery.carouFredSel-6.2.1-packed
//= require isotope.pkgd.min
//= require scripts

function get_ETAStr(eta) {
	var today = new Date();
	var tomorrow = new Date();
	tomorrow.setDate(tomorrow.getDate() + 1);

	var deadline = new Date();
	deadline.setSeconds = 0;
	if (deadline.getMinutes() > 0) {
		deadline.setMinutes(0);
		deadline.setHours(deadline.getHours() + 1);
	}
	deadline.setHours(deadline.getHours() + eta);

	var result = '';

	var hh = deadline.getHours();
	if (hh < 12) {
		if (hh == 0) hh = 12;
		result = hh + ':00am ';
	} else {
		if (hh == 12) hh = 24;
		result = (hh - 12) + ':00pm ';
	}

	if (today.toDateString() == deadline.toDateString()) {
		result += 'today';
	} else if (tomorrow.toDateString() == deadline.toDateString()) {
		result += 'tomorrow';
	} else {
		var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
		result += days[ deadline.getDay() ];
	}

	return result;
}

;(function($, window, document, undefined) {
	var $win = $(window);
	var $doc = $(document);

	$doc.ready(function() {
		//  Popup
		var myModal = $('#myModal');

		function popup(product) {
			if ( myModal.length ) {
				myModal.find(".ico-badge img").attr('src', product.thumbnail);
				myModal.find(".section-task .section-head .section-title").text(product.title);
				myModal.find(".section-task .section-head .section-subtitle").text(product.subheading);
				myModal.find(".section-task .section-head .section-desc").html(product.description);
				myModal.find(".section-task .section-actions .price").text(product.price);
				myModal.find(".section-task .section-body .steps .step p span.eta").text(get_ETAStr(product.eta_from_now));

				myModal.find(".section-task .section-actions input[name='product']").val(product.id);

				if ( product.custom_data ) {
					myModal.find(".custom-data .profile-alt").show();

					if (product.custom_data.result) {
						myModal.find(".custom-data .slider-logo").show();
						myModal.find(".custom-data .slider-logo img").attr('src', product.custom_data.result);
					} else {
						myModal.find(".custom-data .slider-logo").hide();
					}

					myModal.find(".custom-data .profile-alt .avatar img").attr('src', product.custom_data.seller.avatar);
					myModal.find(".custom-data .profile-alt .profile-label img").attr('src', product.custom_data.company.logo);

					myModal.find(".custom-data .profile-alt .profile-body .custom-data-title").text(product.title);
					myModal.find(".custom-data .profile-alt .profile-body .custom-data-seller-name").text(product.custom_data.seller.name);
					myModal.find(".custom-data .profile-alt .profile-body .custom-data-company-name").text(product.custom_data.company.name);
				} else {
					myModal.find(".custom-data .slider-logo").hide();
					myModal.find(".custom-data .profile-alt").hide();
				}

				myModal
				.on('show.bs.modal', function (e) {
					$('.wrapper').addClass('blur-content');				
				})
				.on('hidden.bs.modal', function (e) {
					$('.wrapper').removeClass('blur-content');
					window.history.pushState('home', 'Speedlaner', '/');
				});

				myModal.modal('show');

				window.history.pushState('page2', product.title, '/products/' + product.id);
			};
		}
		$(".modal-link").on('click', function(e) {
			e.preventDefault();
			$task = $(this);
			$.get($task.attr('href') + '.json', function(json){
				popup(json.product);
			}, 'json');
		});

		$win.on('load', function () {
			var carouselIntro = $(".slider-intro .slides");
			// SLider Intro
			carouselIntro.carouFredSel({
				onCreate: function () {
					$win.on('resize', function () {
						carouselIntro.parent().add(carouselIntro).height(carouselIntro.children().first().height());
					}).trigger('resize');
				},				
				scroll: {
					fx: "crossfade"
				},
				responsive:true,
				auto: false,
				pagination: ".slider-intro .slider-paging"
			});
		});

		// initialize isotope
		popover();
		isotope();

		$('form.search input[name=q]').on('keydown', function(e) {
			if (e.keyCode == 13 && $(this).val().trim() == '') {
				e.preventDefault();
			}
		});

		$(".btn-toggle").on('click', function(e){
			if ($(this).attr('for')) {
				$elem = $( $(this).attr('for') );
				if ($elem.length > 0) {
					$elem.toggle();
				}
			}
		});

		$(".btn-contact-intercom").on('click', function(e) {
			if ( $('.intercom-launcher-button').length > 0 ) {
				$('.intercom-launcher-button').trigger('click');
			}
			e.preventDefault();
		});

		$(".modal-link.active-true").trigger('click');
	});

	function isotope () {
		var masonryWall = $('.isotope-items');

		if ( masonryWall.length ) {
			masonryWall.isotope({
				itemSelector: '.isotope-item'
			});
		};

		$('.nav-tasks').on('click', 'a', function(event) {
			event.preventDefault();

			$(this).closest('li').addClass('active').siblings().removeClass('active');

			masonryWall.isotope({
				filter: $(this).attr('href')
			});
		});

		$('.section-tasks .tasks .isotope-items li.isotope-item').each(function(ind) {
			if (ind < 7) {
				$(this).addClass('isotope-init-item');
			}

			if (ind == $('.section-tasks .tasks .isotope-items li.isotope-item').length - 1) {
				masonryWall.isotope({
					filter: '.isotope-init-item'
				});
			}
		});
	}

	function popover () {
		// POPOVERS
		var $div = $('.popover');

		$('a.task').mousemove(function(e){
		    $div.css({
		        top: e.pageY + 10 + 'px',
		        left: e.pageX + 10 + 'px'
		    });
		})
		.hover(function(){
			if ( $(this).attr('for-eta') ) {
		    	$div.show();

		    	$div.find('.eta').text( $(this).attr('for-eta') );
		    	if ( $(this).attr('for-testimorial') ) {
		    		$div.find(".popover-header").attr( 'src',$(this).attr('for-testimorial') );
		    		$div.find(".popover-header").show();
		    	} else {
		    		$div.find(".popover-header").hide();
		    	}
		    }
		}, function(){
		    $div.hide();
		});
	}
})(jQuery, window, document);