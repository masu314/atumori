$(document).ready(function() {
  function appendOption(category){
  var html = `<option value="${category.id}">${category.name}</option>`;
  return html;
  }
  function appendChildrenBox(insertHTML){
    var childSelectHtml = "";
    childSelectHtml = `<select class="search-select-child" id="search_category_id" name="q[category_id_eq]">
                        <option value="">サブカテゴリー</option>
                        ${insertHTML}
                      </select>`;
    $('.append__category').append(childSelectHtml);
  }
  $('#search_category_id').on('change',function(){
    var parentId = document.getElementById('search_category_id').value;
    if (parentId != ""){
      $.ajax({
        url: '/posts/get_category_children/',
        type: 'GET',
        data: { parent_id: parentId },
        dataType: 'json'
      })
      .done(function(children){
        $('.search-select-child').remove();
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenBox(insertHTML);
        if (insertHTML == "") {
          $('.search-select-child').remove();
        }
      })
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    } else {
      $('.search-select-child').remove();
    }
  });

  $('#search_btn').click(function(e) {
    var value = $('.search-select-child').val();
    if ($('.search-select-child').val() == "") {
      $('.search-select-child').remove();
    } else {
    }
  });
});
