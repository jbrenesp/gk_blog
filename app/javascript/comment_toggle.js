document.addEventListener("turbo:load", function () {
  const toggle = document.getElementById("toggle-comment");
  const form = document.getElementById("comment-form");

  if (!toggle || !form) return;

  toggle.addEventListener("click", function () {
    form.classList.toggle("active");
  });
});