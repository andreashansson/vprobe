$(document).ready(function(){
  function addBtnListener(){
	if(window.location.pathname.lastIndexOf('edit') != -1){
		$(this).parents('.scriptForm').hide();
		$(this).parents('.scriptForm').find('.deleted').val(true);
	}else{
		$(this).parents('.scriptForm').remove();
	}
  }

  //$("#test").click(function(){
  $("#addNewScript").click(function(){
    console.log("add new script clicked");
    $("#scriptSet").append($("#new_script_form").html());
    $(".btn.btn-danger > .fa.fa-trash-o").unbind();
    $(".btn.btn-danger > .fa.fa-trash-o").click(addBtnListener);
  });

  $("#test").click(function() {
    console.log("test clicked");
  //  $(".script-list li:first").clone().appendTo(".script-list");
    //$(".parameter-list li:first").clone().appendTo(".parameter-list");
    //$(".button-list li:first").clone().appendTo(".button-list");
    $(".parameter-list").append($(".parameter-content").html());
    $(".script-list").append($(".script-content").html());

    $(".btn.btn-danger > .fa.fa-trash-o").unbind();
    $(".btn.btn-danger > .fa.fa-trash-o").click(addBtnListener);

  });

  $(".btn.btn-danger > .fa.fa-trash-o").click(addBtnListener);
});
