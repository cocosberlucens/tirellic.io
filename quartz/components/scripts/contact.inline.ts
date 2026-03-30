document.addEventListener("nav", () => {
  document.querySelectorAll<HTMLAnchorElement>("[data-u][data-d]").forEach((el) => {
    const addr = el.getAttribute("data-u") + "@" + el.getAttribute("data-d")
    el.setAttribute("href", "mailto:" + addr)
  })
})
