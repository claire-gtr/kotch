import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["collection", "address", "modal"]

  locationSelect(event) {
    const locationID = event.currentTarget.dataset.id;
    this.modalTarget.style.display = "none";
    this.addressTarget.classList.add('hidden');
    this.collectionTarget.classList.remove('hidden');

    console.log();
  }

}
