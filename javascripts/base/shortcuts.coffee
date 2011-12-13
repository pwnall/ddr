# Document-scoped select.
$D = (cssSelector) -> document.querySelector cssSelector

# Element-based select.
$E = (cssSelector, base) -> base.querySelector cssSelector

# Parse HTML fragment.
$H = (html) ->
  range = document.createRange()
  range.selectNode document.body
  range.createContextualFragment html

# Extend window, for debugging purposes.
window['$D'] = $D
window['$E'] = $E
window['$H'] = $H
