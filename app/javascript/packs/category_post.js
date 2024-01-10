$(document).on('turbolinks:load', function() {
  function appendOption(category){
  var html = `<option value="${category.id}">${category.name}</option>`;
  return html;
  }
  function appendChildrenBox(insertHTML){
    var childSelectHtml = "";
    childSelectHtml = `<div class="row mb-3" id="children_wrapper">
                        <label class="col-sm-3 col-form-label" local="true" for="post_category_id">サブカテゴリー</label>
                        <div class="col-sm-9 category__child">
                          <select id="child__category" name="post[category_id]" class="select_field form-control">
                            <option value="">---</option>
                            //optionタグを埋め込む
                            ${insertHTML}
                          </select>
                        </div>
                      </div>`;
    $('.append__category').append(childSelectHtml);
  }
  $('#post_category_id').on('change',function(){
    var parentId = document.getElementById('post_category_id').value;
    if (parentId != ""){
      $.ajax({
        url: '/posts/get_category_children/',
        type: 'GET',
        data: { parent_id: parentId },
        dataType: 'json'
      })
      .done(function(children){
        $('#children_wrapper').remove();
        var insertHTML = '';
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenBox(insertHTML);
        if (insertHTML == "") {
          $('#children_wrapper').remove();
        }
        })
        .fail(function(){
          alert('カテゴリー取得に失敗しました');
        })
    }else{
      $('#children_wrapper').remove();
    }
  });
});

