import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['button']

  toggle() {
    this.buttonTarget.classList.toggle('hidden');
  }
}
