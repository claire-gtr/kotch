import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    enableTime: true,
    dateFormat: "Y-m-d H:i",
    minDate: "today",
    maxDate: new Date().fp_incr(45)
  });
}

export { initFlatpickr };
