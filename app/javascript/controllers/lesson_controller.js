import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  down(event) {
    const lessonID = event.currentTarget.dataset.id;
    const chevronUp = document.querySelector(`.chevronUp-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronUp.classList.remove('hidden');
  }

  up() {
    const lessonID = event.currentTarget.dataset.id;
    const chevronDown = document.querySelector(`.chevronDown-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronDown.classList.remove('hidden');
  }
}
