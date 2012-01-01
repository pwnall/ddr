# Instantiates the main controller and view for the page.
BootLdr.initializer 'page_controller', ['dom_load'], ->
  domRoot = document.querySelector('body')
  pageName = domRoot.getAttribute('id').replace(/\-view$/, '')
  pageNameBits = for bit in pageName.split('-')
    bit[0].toUpperCase() + bit[1..]   
  controllerName = pageNameBits.join('') + 'Controller'
  viewName = pageNameBits.join('') + 'View'

  # TODO(pwnall): find a better way to locate the classes  
  viewClass = eval(viewName)
  controllerClass = eval(controllerName)

  window.view = new viewClass domRoot
  window.controller = new controllerClass view
  
