import interact from 'interactjs';

document.addEventListener("trix-attachment-add", function(event) {
  const attachment = event.attachment;
  if (attachment.file) {
    resizeImage(attachment);
  }
});
function resizeImage(attachment) {
  const file = attachment.file;
  const reader = new FileReader();
  reader.onloadend = () => {
    const image = new Image();
    image.src = reader.result;
    image.onload = () => {
      const canvas = document.createElement('canvas');
      const max_size = 800;
      let width = image.width;
      let height = image.height;
      if (width > height) {
        if (width > max_size) {
          height *= max_size / width;
          width = max_size;
        }
      } else {
        if (height > max_size) {
          width *= max_size / height;
          height = max_size;
        }
      }
      canvas.width = width;
      canvas.height = height;
      canvas.getContext('2d').drawImage(image, 0, 0, width, height);
      canvas.toBlob((blob) => {
        const file = new File([blob], attachment.file.name, { type: blob.type });
        const newAttachment = new Trix.Attachment({ file, sgid: attachment.sgid });
        event.target.editor.insertAttachment(newAttachment);
        event.target.editor.deleteContent();
      }, file.type);
    }
  }
  reader.readAsDataURL(file);
}
document.addEventListener('trix-change', function () {
  initializeInteract();
});
function initializeInteract() {
  interact('trix-editor img')
    .resizable({
      edges: { left: true, right: true, bottom: true, top: true },
    })
    .on('resizemove', function (event) {
      const target = event.target;
      target.style.width  = event.rect.width + 'px';
      target.style.height = event.rect.height + 'px';
    });
}
