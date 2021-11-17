import $ from 'jquery';
import 'select2';

const initSelect2 = () => {
  $('.select2').select2({
    placeholder: "Sélectionnez des amis"
  });
};

export { initSelect2 };
