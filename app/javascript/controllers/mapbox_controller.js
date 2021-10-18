import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collection", "address", "modal", "container"]

  locationSelect(event) {
    const locationID = event.currentTarget.dataset.id;
    const algoliaPlaces = document.querySelector('.algolia-places');
    const body = document.querySelector('body');
    const backdrop = document.querySelector('.modal-backdrop');

    this.modalTarget.setAttribute('aria-hidden', 'true');
    this.modalTarget.removeAttribute('aria-modal');
    this.modalTarget.removeAttribute('role');
    this.modalTarget.style.display = 'none';
    this.modalTarget.classList.remove('show');
    body.classList.remove('modal-open');
    body.style = '';
    backdrop.remove();

    // window.click();
    // this.containerTarget.click();

    this.addressTarget.value = '';
    this.addressTarget.disabled = true;
    this.addressTarget.removeAttribute('placeholder');
    // this.addressTarget.classList.add('disabled');
    // algoliaPlaces.classList.add('hidden');
    // algoliaPlaces.remove();

    // this.collectionTarget.classList.remove('hidden');
    this.collectionTarget.disabled = false;
    this.collectionTarget.value = locationID;
  }

  addressSelect() {
    // this.addressTarget.removeAttribute('disabled');
    // this.collectionTarget.disabled = true;
    // this.collectionTarget.value = '';
  }
}
