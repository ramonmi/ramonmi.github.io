document$.subscribe(() => {
  const year = document.querySelector("#copyright-year")
  if (year) year.textContent = new Date().getFullYear()
})
