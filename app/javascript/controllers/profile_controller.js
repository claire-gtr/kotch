import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [
  'futurLesson',
  'futurLessonTable',
  'oldLesson',
  'oldLessonTable',
  'subscription',
  'subscriptionData',
  'nextCoaching',
  'nextCoachingTable',
  'requestCoaching',
  'requestCoachingTable',
  'pastCoaching',
  'pastCoachingTable'
]

  next(event) {
    this.nextCoachingTableTarget.classList.toggle('hidden');
    this.requestCoachingTarget.classList.toggle('hidden');
    this.pastCoachingTarget.classList.toggle('hidden');
  }

  request(event) {
    this.nextCoachingTarget.classList.toggle('hidden');
    this.requestCoachingTableTarget.classList.toggle('hidden');
    this.pastCoachingTarget.classList.toggle('hidden');
  }

  past(event) {
    this.nextCoachingTarget.classList.toggle('hidden');
    this.requestCoachingTarget.classList.toggle('hidden');
    this.pastCoachingTableTarget.classList.toggle('hidden');
  }

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
