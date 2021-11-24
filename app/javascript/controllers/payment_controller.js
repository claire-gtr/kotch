import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['button']

  toggle() {
    this.buttonTarget.classList.toggle('hidden');
  }

  toggleSubscription (event) {
    const sessionID = event.currentTarget.dataset.sessionId;
    const button = document.querySelector(`.session-${sessionID}`);
    button.classList.toggle('hidden');
  }
}
