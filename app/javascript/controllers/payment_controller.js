import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['button']

  toggle() {
    this.buttonTarget.classList.toggle('hidden');
  }

  toggleSubscription (event) {
    event.stopImmediatePropagation();
    // event.preventDefault();

    const sessionID = event.currentTarget.dataset.sessionId;
    const stripeButton = document.querySelector(`.button-${sessionID}`);
    const cgvCheckbox = document.querySelector(`.checkbox-${sessionID}`);
    const cgvText = document.querySelector(`.cgv-text-${sessionID}`);
    console.log(cgvCheckbox.checked)
    if (event.currentTarget === cgvCheckbox) {
      cgvCheckbox.checked = !cgvCheckbox.checked;
    } else if (event.currentTarget === stripeButton && cgvCheckbox.checked === true) {
      let stripe = Stripe("<%= ENV["STRIPE_PUBLISHABLE_KEY"] %>");
      let checkoutButtons = document.querySelectorAll('.checkout-button');
      checkoutButtons.forEach(checkoutButton => {
        checkoutButton.addEventListener('click', function () {
          stripe.redirectToCheckout({
            sessionId: checkoutButton.dataset.sessionId
          })
          .then(function (result) {
            if (result.error) {
              // If `redirectToCheckout` fails due to a browser or network
              // error, display the localized error message to your customer.
              let displayError = document.getElementById('error-message');
              displayError.textContent = result.error.message;
            }
          });
        });
      });

      const event = new Event('click');
      stripeButton.dispatchEvent(event);
    } else {
      cgvText.classList.remove('hidden');
    }
  }
}
