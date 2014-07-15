# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
do ($ = jQuery, window, document) ->

  # window and document are passed through as local variable rather than global
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = "starRating"
  defaults =
    property: "value"

  # The actual plugin constructor
  class StarRating

    constructor: (element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @$element = $(element)
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName

      @value = 0

      @init()

    init: ->
      self = @
      @$input = $(@$element).find('[type="hidden"]')
      @$stars = $(@$element).find('.rating-star')
      console.log "-----------Hallo"
      @$stars.on 'click', (e) ->
        console.log "-----------Hallo"
        self.value = $(@).index()
        self.render()

    render: ->
      self = @
      @$stars.removeClass('rating-on').addClass('rating-off')

      renderStar = (i) ->
        star = self.$stars.eq(i)
        if i < self.value
          star.removeClass('rating-off').addClass('rating-on')
        
      renderStar(i) for i in [0...@$stars.length]

      @$input.val(@value)

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new StarRating @, options
       
