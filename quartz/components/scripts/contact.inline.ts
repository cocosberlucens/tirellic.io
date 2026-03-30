document.addEventListener("nav", () => {
  document.querySelectorAll("[data-u][data-d]").forEach((el) => {
    const u = el.getAttribute("data-u")
    const d = el.getAttribute("data-d")
    const mailto = "mailto:" + u + "@" + d

    // Replace element with a clean <a> that Quartz SPA won't touch
    const link = document.createElement("a")
    link.href = mailto
    link.textContent = el.textContent
    link.dataset.routerIgnore = ""
    link.style.cursor = "pointer"
    el.replaceWith(link)
  })
})
