document.addEventListener("nav", () => {
  document.querySelectorAll("[data-u][data-d]").forEach((el) => {
    const addr = el.getAttribute("data-u") + "@" + el.getAttribute("data-d")
    const mailto = "mailto:" + addr
    if (el.tagName === "A") {
      ;(el as HTMLAnchorElement).href = mailto
    }
    // Always add click handler as fallback (works for both <a> and <span>)
    ;(el as HTMLElement).style.cursor = "pointer"
    el.addEventListener("click", (e) => {
      e.preventDefault()
      e.stopPropagation()
      window.location.href = mailto
    })
  })
})
