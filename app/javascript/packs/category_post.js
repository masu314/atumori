$(document).ready(function() {
  //選択リストの表示に必要なoptionタグを作成
  function appendOption(category){
    var html = `<option value="${category.id}">${category.name}</option>`;
    return html;
  }
  //子カテゴリー用の選択リストを作成
  function appendChildrenList(insertHTML){
    var childSelectHtml = "";
    childSelectHtml = `<div class="row mb-3" id="children_wrapper">
                        <label class="col-sm-4 col-form-label required" local="true" for="post_category_id">サブカテゴリー</label>
                        <div class="col-sm-8 category__child">
                          <select class="select_field form-control" id="post_category_id" required="required" name="post[category_id]">
                            <option value="">選択してください</option>
                            ${insertHTML}
                          </select>
                        </div>
                      </div>`;
    $('.append__category').append(childSelectHtml);
  }
  //親カテゴリーの選択リストの値が変更された際
  $('#post_category_id').on('change',function(){
    //親カテゴリーの値を取得
    var parentId = document.getElementById('post_category_id').value;
    if (parentId != ""){
      $.ajax({
        url: '/posts/get_category_children/',
        type: 'GET',
        data: { parent_id: parentId },
        dataType: 'json'
      })

      //データの取得に成功した時の処理
      .done(function(children){
        //現在表示されている子カテゴリーの選択リストを削除
        $('#children_wrapper').remove();
        var insertHTML = '';
        //親カテゴリーに紐づく子カテゴリーの選択リストを表示
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenList(insertHTML);
        if (insertHTML == "") {
          //親カテゴリーに紐づく子カテゴリーの選択リストがなければ、選択リストの表示を削除
          $('#children_wrapper').remove();
        }
        //既存の子カテゴリーの選択リストを削除
        $('#exist_children_wrapper').remove();
      })

      //データの取得に失敗した時の処理
      .fail(function(){
          alert('カテゴリー取得に失敗しました');
      })
    }else{
      $('#children_wrapper').remove();
    }
  });
});

