import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    enableTime: true,
    time_24hr: true,
    dateFormat: "d/m/Y - H:i",
    minDate: "today",
    maxDate: new Date().fp_incr(31)
  });
}

const initFlatpickrBirth = () => {
  flatpickr(".datepickerbirth", {
    dateFormat: "d/m/Y",
    maxDate: "today"
  });
}

export { initFlatpickr };
export { initFlatpickrBirth };
