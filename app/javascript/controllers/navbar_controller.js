import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "burger", "menu" ];

  burgerClicked () {
    this.burgerTarget.classList.toggle("is-active");
    this.menuTarget.classList.toggle("is-active");
  }
}
