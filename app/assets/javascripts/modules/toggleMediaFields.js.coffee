# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "toggleMediaFields"
  defaults =
    property: "value"

  # The actual plugin constructor
  class ToggleMediaFields
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
      @$body = $('body')
      @$tab = @$element.find('.media-type-form')
      @$yt_tab = @$element.find('#yt-tab')
      @$sc_tab = @$element.find('#sc-tab')
      @$field = @$element.find('.media-type-field')

      #@$tab.on 'click', => @render(e)
      @$body.on 'click', (e) -> 
        if e.target.id == "sc-type" or e.target.id == "yt-type"
          self.$id = e.target.id
          self.render()
        else if e.target.id == "profile_soundcloud" or e.target.id == "profile_youtube" or e.target.id == "sc-btn" or e.target.id == "yt-btn"
          return true
        else
          self.close()

    render: ->
      self = @
      $("##{self.$id}").hide()
      $("##{self.$id}-field").show()

    close: ->
      @$field.hide()
      @$tab.show()


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new ToggleMediaFields @, options
       
