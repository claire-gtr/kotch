import places from 'places.js';

const initAutocomplete = () => {
  const addressInput = document.getElementById('location_name');
  if (addressInput) {
    places({ container: addressInput });
  }
};

const initAutocompleteLieu = () => {
  const lieuInput = document.getElementById('lieu');
  if (lieuInput) {
    places({ container: lieuInput });
  }
};

export { initAutocomplete };
export { initAutocompleteLieu };
