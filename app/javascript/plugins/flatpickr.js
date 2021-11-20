import flatpickr from "flatpickr";

const initFlatpickr = () => {
  flatpickr(".datepicker", {
    enableTime: true,
    time_24hr: true,
    dateFormat: "d/m/Y - H:i",
    minDate: "today",
    maxDate: new Date().fp_incr(45)
  });
}

const initFlatpickrBirth = () => {
  flatpickr(".datepickerbirth", {
    dateFormat: "d/m/Y"
  });
}

export { initFlatpickr };
export { initFlatpickrBirth };
