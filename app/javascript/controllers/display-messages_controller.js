import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "messages", 'booking' ]

  display(event) {
    const idMessagesCard = event.target.id;
    const cardToDisplay = document.getElementById(`messages-${idMessagesCard}`);
    const cardToHide = document.querySelector('.active-card-messages');
    const parentCardToHide = document.querySelector('.card-dark-blue')
    const parentCardtoDisplay = event.target.closest(".card-white");
    // add class card-dark blue to this one
    // remove card-dark-blue to the other one
    if (cardToDisplay === cardToHide) {
      return
    } else {
      cardToDisplay.classList.remove('d-none');
      cardToDisplay.classList.add('active-card-messages');
      cardToHide.classList.add('d-none');
      cardToHide.classList.remove('active-card-messages');
      parentCardtoDisplay.classList.add('card-dark-blue');
      parentCardToHide.classList.remove('card-dark-blue');
    }
  }
}
