import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "messages", 'booking' ]

  connect() {
    console.log("hello");
  }

  display() {
    console.log(this.data);

    const allMessages = this.messagesTarget;
    // console.log(document.getElementById('2'));
  }
}