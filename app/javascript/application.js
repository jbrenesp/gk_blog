// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

import "trix"
import "@rails/actiontext"

function setupDropdown() {
  const dropdown = document.querySelector(".dropdown");
  const button = document.querySelector(".dropdown-btn");

  if (!dropdown || !button) return;

  button.addEventListener("click", () => {
    dropdown.classList.toggle("open");
  });

  document.addEventListener("click", (e) => {
    if (!dropdown.contains(e.target)) {
      dropdown.classList.remove("open");
    }
  });
}

document.addEventListener("turbo:load", setupDropdown);