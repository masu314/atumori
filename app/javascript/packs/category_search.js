import $ from 'jquery'

$(document).ready(function() {
  //選択リストの表示に必要なoptionタグを作成
  function appendOption(category){
    var html = `<option value="${category.id}">${category.name}</option>`;
    return html;
  }
  //子カテゴリー用の選択リストを作成
  function appendChildrenList(insertHTML){
    var childSelectHtml = "";
    childSelectHtml = `<select class="search-select-child" id="search_category_id" name="q[category_id_eq]">
                        <option value="">サブカテゴリー</option>
                        ${insertHTML}
                      </select>`;
    $('.append__category').append(childSelectHtml);
  }
  //親カテゴリーの選択リストの値が変更された際
  $('#search_category_id').on('change',function(){
    //親カテゴリーの値を取得
    var parentId = document.getElementById('search_category_id').value;
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
        $('.search-select-child').remove();
        var insertHTML = '';
        //親カテゴリーに紐づく子カテゴリーの選択リストを表示
        children.forEach(function(child){
          insertHTML += appendOption(child);
        });
        appendChildrenList(insertHTML);
        //親カテゴリーに紐づく子カテゴリーの選択リストがなければ、選択リストの表示を削除
        if (insertHTML == "") {
          $('.search-select-child').remove();
        }
      })
      //データの取得に失敗した時の処理
      .fail(function(){
        alert('カテゴリー取得に失敗しました');
      })
    } else {
      $('.search-select-child').remove();
    }
  });

  //小カテゴリーの選択リストが表示されている状態で、親カテゴリーのみ選択して検索した場合
  $('#search_btn').click(function(e) {
    var value = $('.search-select-child').val();
    if ($('.search-select-child').val() == "") {
      //親カテゴリーの値のみで検索できるように、小カテゴリーの選択リストを削除する
      $('.search-select-child').remove();
    }
  });
});
