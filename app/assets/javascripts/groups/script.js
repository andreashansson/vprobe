$(function() {
    setTimeout(function(){
      $(".notice").hide(100);
    }, 10000);

    $(".notice").click(function() {
      $(this).hide(100);
    });

    $('input[value="Create"]').click(function() {
        console.log("create");
    });
    $('input[value="Update"]').click(function() {
        console.log("update");
    });
});
