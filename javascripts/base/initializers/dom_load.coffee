# Implements the domload boot loader event.
 
BootLdr.event 'dom_load'
document.defaultView.addEventListener 'load',
                                      (-> BootLdr.fireEvent 'dom_load'), false
