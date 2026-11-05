import { Controller } from "@hotwired/stimulus"

// Shows the selected cover image before the form is submitted.
export default class extends Controller {
  static targets = ["input", "image"]

  show() {
    const file = this.inputTarget.files[0]
    if (!file || !file.type.startsWith("image/")) return

    this.imageTarget.src = URL.createObjectURL(file)
    this.imageTarget.classList.remove("d-none")
  }
}
