// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)


// ----------------------------------------------------
// Note(lewagon): ABOVE IS RAILS DEFAULT CONFIGURATION
// WRITE YOUR OWN JS STARTING FROM HERE 👇
// ----------------------------------------------------

// External imports
import "bootstrap";

import "@fontsource/barlow-condensed/100.css";
import "@fontsource/barlow-condensed/200.css";
import "@fontsource/barlow-condensed/300.css";
import "@fontsource/barlow-condensed/400.css";
import "@fontsource/barlow-condensed/500.css";
import "@fontsource/barlow-condensed/600.css";
import "@fontsource/barlow-condensed/700.css";
import "@fontsource/barlow-condensed/800.css";
import "@fontsource/barlow-condensed/900.css";

import "@fontsource/barlow/100.css";
import "@fontsource/barlow/200.css";
import "@fontsource/barlow/300.css";
import "@fontsource/barlow/400.css";
import "@fontsource/barlow/500.css";
import "@fontsource/barlow/600.css";
import "@fontsource/barlow/700.css";
import "@fontsource/barlow/800.css";
import "@fontsource/barlow/900.css";


// Internal imports, e.g:
// import { initSelect2 } from '../components/init_select2';
import "controllers"
import { initUpdateNavbarOnScroll } from '../components/navbar';
import { initFlatpickr } from "../plugins/flatpickr";
import { initFlatpickrBirth } from "../plugins/flatpickr";
// import { initAutocomplete } from "../plugins/init_autocomplete";
import { initAutocompleteLieu } from "../plugins/init_autocomplete";
import { initMapbox } from "../plugins/init_mapbox";
import { initSelect2 } from '../components/init_select2';


document.addEventListener('turbolinks:load', () => {

  initUpdateNavbarOnScroll();

  const keywords = ['utilisateur/inscription', 'utilisateur/modifier-mon-profil', '/inscription-coach'];
  if (keywords.some(el => window.location.pathname.includes(el))) {
    initFlatpickrBirth();
  }

  if (window.location.pathname.includes('/seance-de-sport-personnalisee')) {
    initSelect2();
    initFlatpickr();
    // initAutocomplete();
    initAutocompleteLieu();
    initMapbox();
  }
});
