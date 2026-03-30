document.addEventListener("nav", () => {
  document.querySelectorAll("[data-u][data-d]").forEach((el) => {
    const addr = el.getAttribute("data-u") + "@" + el.getAttribute("data-d")
    if (el.tagName === "A") {
      el.setAttribute("href", "mailto:" + addr)
    } else {
      // For non-anchor elements (e.g. <span> in markdown), make clickable
      el.style.cursor = "pointer"
      el.style.color = "var(--secondary)"
      el.onclick = () => { window.location.href = "mailto:" + addr }
    }
  })
})
