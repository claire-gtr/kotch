import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  down(event) {
    const lessonID = event.currentTarget.dataset.id;
    const chevronUp = document.querySelector(`.chevronUp-${lessonID}`);
    const hiddenBtn = document.querySelector(`.hidden-lesson-btn-${lessonID}`);
    const hiddenBtnCancel = document.querySelector(`.hidden-lesson-btn-cancel-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronUp.classList.remove('hidden');
    hiddenBtn.classList.remove('hidden');
    hiddenBtnCancel.classList.remove('hidden');
  }

  up(event) {
    const lessonID = event.currentTarget.dataset.id;
    const chevronDown = document.querySelector(`.chevronDown-${lessonID}`);
    const hiddenBtn = document.querySelector(`.hidden-lesson-btn-${lessonID}`);
    const hiddenBtnCancel = document.querySelector(`.hidden-lesson-btn-cancel-${lessonID}`);

    event.currentTarget.classList.add('hidden');
    chevronDown.classList.remove('hidden');
    hiddenBtn.classList.add('hidden');
    hiddenBtnCancel.classList.add('hidden');
  }
}
