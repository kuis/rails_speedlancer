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
//= require turbolinks
//= require bootstrap-sprockets
//= require jquery.carouFredSel-6.2.1-packed
//= require isotope.pkgd.min
//= require scripts

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
				myModal.find(".section-task .section-head p").text(product.description);
				myModal.find(".section-task .section-actions a").attr('href', '/tasks/new?product=' + product.id)

				myModal
				.on('show.bs.modal', function (e) {
					$('.wrapper').addClass('blur-content');				
				})
				.on('hidden.bs.modal', function (e) {
					$('.wrapper').removeClass('blur-content');
				});

				myModal.modal('show');
			};
		}
		$(".modal-link").on('click', function(e) {
			e.preventDefault();
			$task = $(this);
			$.get($task.attr('href'), function(json){
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
		    $div.show();
		}, function(){
		    $div.hide();
		});
	}
})(jQuery, window, document);