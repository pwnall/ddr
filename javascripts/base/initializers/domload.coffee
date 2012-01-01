# Implements the domload boot loader event.
 
BootLdr.s.event 'domload'
document.defaultView.addEventListener 'load',
                                      (-> BootLdr.s.fireEvent 'domload'), false
