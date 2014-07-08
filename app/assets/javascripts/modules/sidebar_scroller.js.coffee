# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "sidebarScroller"
  defaults =
    property: "value"

  # The actual plugin constructor
  class SidebarScroller

    constructor: (element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @$element = $(element)
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName

      @init()

    init: ->
      self = @

      $(window).scroll (e) ->
        # Position of the location where the scroller starts & stops.
        scroller_anchor = $("aside").offset().top
        scroller_stopper = $(".new-review").offset().top - 380

        # Check if the user has scrolled and the current position is after the scroller start location and if its not already fixed at the top
        if $(@).scrollTop() >= scroller_anchor
          # Change the CSS of the scroller to hilight it and fix it at the top of the screen.
          $(".booking-teaser").css
            position: "fixed"
            top: "10px"
            bottom: "auto"
            width: "230px"
          
          # Stop scrolling if its next to .new-review
          if scroller_stopper <= $(@).scrollTop() + 10
            # Change the CSS of the scroller to hilight it and fix it at the top of the screen.
            $(".booking-teaser").css
              position: "absolute"
              top: scroller_stopper + "px"

        else if $(@).scrollTop() < scroller_anchor
          # If the user has scrolled back to the location above the scroller anchor place it back into the content.
          
          # Change the CSS and put it back to its original position.
          $(".booking-teaser").css
            position: "relative"
            top: "0"
      

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new SidebarScroller @, options
       
