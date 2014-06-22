do ($ = jQuery, window, document) ->

  # Create the defaults once
  pluginName = "pictureViewer"
  defaults =
    index: 0

  # The actual plugin constructor
  class PictureViewer
    constructor: (element, options) ->
      @$element = $(element)
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()
      @render()

    init: ->
      self = @

      @$thumbs = @$element.find('.thumb')
      @$img_tag = @$element.find('.picture img')

      @picture_url = @$thumbs.eq(0).data("big-picture")

      @$thumbs.on 'click', ->
        self.picture_url = $(@).data("big-picture")
        self.render()

    render: ->
      @$img_tag.attr("src", @picture_url)


  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new PictureViewer @, options
       

