import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['button']

  toggle() {
    this.buttonTarget.classList.toggle('hidden');
  }

  toggleSubscription (event) {
    event.stopImmediatePropagation();

    const sessionID = event.currentTarget.dataset.sessionId;
    const stripeButton = document.querySelector(`.button-${sessionID}`);
    const cgvCheckbox = document.querySelector(`.checkbox-${sessionID}`);
    const cgvText = document.querySelector(`.cgv-text-${sessionID}`);
    console.log(event.currentTarget.checked);
    console.log(cgvCheckbox.checked);
    if (event.currentTarget === cgvCheckbox) {
      event.currentTarget.checked = !event.currentTarget.checked;
    } else if (event.currentTarget === stripeButton && cgvCheckbox.checked === true) {
      const event = new Event('click');
      stripeButton.dispatchEvent(event);
    } else {
      cgvText.classList.remove('hidden');
    }
  }
}
