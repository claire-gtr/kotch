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

  futur(event) {
    this.futurLessonTableTarget.classList.toggle('hidden');
    this.oldLessonTarget.classList.toggle('hidden');
    this.subscriptionTarget.classList.toggle('hidden');
  }

  old(event) {
    this.futurLessonTarget.classList.toggle('hidden');
    this.subscriptionTarget.classList.toggle('hidden');
    this.oldLessonTableTarget.classList.toggle('hidden');
  }

  order(event) {
    this.futurLessonTarget.classList.toggle('hidden');
    this.oldLessonTarget.classList.toggle('hidden');
    this.subscriptionDataTarget.classList.toggle('hidden');
  }
}
