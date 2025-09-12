/* global feather, Quill */

function initQuillEditor() {
  const container = document.querySelector('.quill-editor')
  const instance = Quill.find(container)

  if (instance) return;

  const quill = new Quill(container, {
    theme: 'snow'
  });

  quill.on('text-change', function() {
    $("#quill-content").val(quill.root.innerHTML);
  });
}

document.addEventListener("turbo:load", function() {
  feather.replace();

  $('.select2').select2();

  if ($('.quill-editor').length > 0) {
    initQuillEditor();
  }
});

document.addEventListener("turbo:render", function() {
  $('.select2').select2();

  if ($('.quill-editor').length > 0) {
    initQuillEditor();
  }
})
