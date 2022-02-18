import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "markdown", "html", "preview" ];

  markdownChanged () {
    const markdown = this.markdownTarget.value;
    const converter = new showdown.Converter();
    const html = converter.makeHtml(markdown);
    this.htmlTarget.value = html;
    this.previewTarget.innerHTML = html;
  }
}
