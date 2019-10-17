document.addEventListener('turbolinks:load', function(){
//     $("#giphy_icon").click(function(){
//         $("#giphy_list").slideToggle("fast");
//     });

    $("#giphy_icon").on("click", function(e){
        if($("#giphy_list").is(":hidden")){
            $("#giphy_list").show();
        }else{
            $("#giphy_list").hide();
        }
     
        $(document).one("click", function(){
            $("giphy_list").hide();
        });
     
        e.stopPropagation();
    });
    $("#giphy_icon").on("click", function(e){
        $('#emoji-list').hide()
        e.stopPropagation();
    });

    
  $('#giphy_list').on('click', function(e){
    return false
  })

    var apiKey ='Mrjdc0YDiu0GDGzkciE04Av5N2SJ1zSN';
    var query = 'cat';
    var url = "https://api.giphy.com/v1/gifs/search?api_key="+apiKey+"&q=";

    var form = document.querySelector("#giphy_list form");
    var input = document.querySelector('#giphy_list input[type="text"]');
    var result = document.querySelector("#giphy_list .result");


    function search(e) {
        e.preventDefault();
        query = input.value;
        $("#giphy_resault").empty();
        makeRequest(query);
    }

    function createGif(gif,url){
        var item = document.createElement('div');
        var img = document.createElement('img');
        
        img.src = gif;
        
        result.appendChild(item);
        item.appendChild(img);
        img.addEventListener('click', sendImgMarkDown);
    }
    function makeRequest(query) {
        xhr = new XMLHttpRequest();

        xhr.onload = function() {
            var response = JSON.parse(this.responseText);
            console.log(response)
            response.data.map(function(gif){
            createGif(gif.images.fixed_height_downsampled.url,gif.url)
            })
        };
        xhr.open(
            "GET",
        url+query,
            true
        );
        xhr.send();
        $("#giphy_form").val('')
    }

    form.addEventListener("submit", search);

    function sendImgMarkDown() {
        var markdown = '![此圖無法顯示]('+ this.src +')';
        var inputgiphy = document.querySelector("#message_input"); 
        inputgiphy.value = markdown;
        $("#new_message").submit();
        $("#giphy_resault").empty();
        $("#giphy_list").hide();
    
    }

});
