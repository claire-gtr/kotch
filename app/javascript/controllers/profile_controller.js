import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
  'futurLesson',
  'futurLessonTable',
  'oldLesson',
  'oldLessonTable',
  'subscription',
  'subscriptionData'
]

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
}
