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
// Lets the dashboard tell real visitors (who run JavaScript) from bots
function trackPageView() {
  const token = document.querySelector('meta[name="csrf-token"]')?.content;

  fetch("/page_views", {
    method: "POST",
    headers: { "Content-Type": "application/json", "X-CSRF-Token": token },
    body: JSON.stringify({ path: window.location.pathname }),
    keepalive: true
  }).catch(() => {});
}

document.addEventListener("turbo:load", trackPageView);
