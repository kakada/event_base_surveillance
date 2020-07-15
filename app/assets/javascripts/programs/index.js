EBS.ProgramsNew = (() => {
  return {
    init
  }

  function init() {
    onChangeLogoFile();
    onClickButtonDeleteLogo();
  }

  function onClickButtonDeleteLogo() {
    $('.btn-delete').on('click', function() {
      showDefaultImage();
      hideDeleteButton();
      setCheckRemoveAvatar();
    })
  }

  function onChangeLogoFile() {
    $("#program_logo").change(function() {
      readURL(this);
      showButtonDelete();
      setUncheckRemoveAvatar();
    });
  }

  function setCheckRemoveAvatar() {
    $('#program_remove_logo').attr('checked', true);
  }

  function showDefaultImage() {
    $('.program-logo').attr('src', $('.program-logo').data('default'));
  }

  function hideDeleteButton() {
    $('.btn-delete').addClass('d-none');
  }

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function(e) {
        $('.program-logo').attr('src', e.target.result);
      }

      reader.readAsDataURL(input.files[0]);
    }
  }

  function showButtonDelete() {
    $('.btn-delete').removeClass('d-none');
  }

  function setUncheckRemoveAvatar() {
    $('#user_remove_avatar').attr('checked', false);
  }
})();


EBS.ProgramsCreate = EBS.ProgramsNew
EBS.ProgramsEdit = EBS.ProgramsNew
EBS.ProgramsUpdate = EBS.ProgramsNew
