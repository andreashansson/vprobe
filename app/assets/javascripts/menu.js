$(function(){
	var page = window.location.href.split(window.location.host)[1];
	$('ul.nav.nav-tabs > li > a').each(function(){
		if($(this).attr('href') == page){
			$(this).parent().addClass("active");
		}
	});

	$('ul.nav.nav-tabs > li > a').on('click', function(e){
		e.preventDefault();
		$(this).parents().find('li').each(function(){
			$(this).removeClass('active');
		});
		$(this).parent().addClass('active');
		window.location.href = $(this).attr('href');
	});
});