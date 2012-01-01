# Manages the dependencies involved in starting up the game.
#
# This class must be loaded before everything else. Any other class may rely on
# it for load ordering.
class BootLdrClass
  # Creates an empty boot loader with no initializers.
  constructor: ->
    # Initializer functions.
    @functions = {}
    # Dependencies for each initializer.
    @deps = {}
    # Counts the dependencies for each initializer. 
    @depCount = {}
    # Counts the already satisfied dependencies for each initializer.
    @completeDepCount = {}
    # The initializers that depend on each initializer / event.
    @reverseDeps = {}
    # Associates all the completed initializers / events to true.
    @completed = {}
    # Stack of names of initializers that are eligible to be called.
    @ready = []
    # Set to true inside _boot()
    @booting = false
    
  # Registers an event that can be used for dependency resolution.
  #
  # @param {String} name used to identify the event 
  event: (name) ->
    if @functions[name]
      throw new Error "Already registered event / initializer named #{name}"
    
    @functions[name] = true
    @reverseDeps[name] ||= []
  
  # Registers an initializer function.
  #
  # If the initializer's dependencies are satisfied, it may be called before
  # this method returns.
  #
  # @param {String} name used to identify the initializer
  # @param {Array} dependencies array of names of initializers / events
  # @param {Function} fn the initializer function to be called
  initializer: (name, dependencies, fn) ->
    if @functions[name]
      throw new Error "Already registered event / initializer named #{name}"    
    
    @functions[name] = fn    
    @reverseDeps[name] ||= []
    
    @deps[name] ||= {}
    @depCount[name] ||= 0
    @completeDepCount[name] ||= 0
    for dependency in dependencies
      @_dependsOn dependency, name      
  
    if @completeDepCount[name] == @depCount[name]
      @ready.push name
      @_boot()
  
  # Adds a dependency between initializers / events.
  #
  # @param {String} dependency name used to identify the event / initializer
  # @return {Boolean} true if the dependency was added, or false if it was
  #                   already recorded
  dependsOn: (dependency, dependent) ->
    unless @functions[dependent] and @functions[dependent] != true
      throw new Error "Invalid initializer name #{dependent}"
    
    return if @deps[dependent][dependency]
    if @completed[dependent]
      throw new Error "Too late -- #{dependent} completed"
    @_dependsOn dependency, dependent

  # Marks an event as fired, allowing initializers depending on it to run.
  #
  # @param {String} name used to identify the event in an earlier event() call
  fireEvent: (name) ->
    unless @functions[name] == true
      throw new Error "Invalid event name #{name}"
    @_completed name
    @_boot()
    
  # Unchecked implementation of dependsOn(). Do not call directly.
  _dependsOn: (dependency, dependent) ->
    return false if @deps[dependent][dependency]
    @depCount[dependent] += 1
    @deps[dependent][dependency] = true
    @reverseDeps[dependency] ||= []
    @reverseDeps[dependency].push dependent
    @completeDepCount[dependent] += 1 if @completed[dependency]
    true
    
  # Marks an event or function as completed.
  #
  # This method does not call any initializers that may become eligible to run.
  _completed: (name) ->
    if @completed[name]
      throw new Error "Initializer / event #{name} completed twice?!"
    @completed[name] = true
    for next in @reverseDeps[name]
      @completeDepCount[next] += 1
      if @completeDepCount[next] == @depCount[next]
        @ready.push next

  # Executes initializers that are eligible to run.
  #
  # If other initializers become eligible during the method call, they are run
  # as well.
  _boot: ->
    return if @booting
    try
      @booting = true
      while @ready.length != 0
        next = @ready.pop()
        @functions[next]()
        @_completed next
    finally
      @booting = false

BootLdr = new BootLdrClass  # Singleton.
window.BootLdr = BootLdr  # Export.
