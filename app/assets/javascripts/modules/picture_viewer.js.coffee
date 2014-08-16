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

      @count = 1

    init: ->
      self = @

      @$thumbs = @$element.find('.thumb')
      @picture_url = @$thumbs.eq(0).data("review")

      @$img_tag = @$element.find('.picture img')

      @$thumbs.on 'click', ->
        self.picture_url = $(@).data("review")
        self.render()

      @$img_tag.on 'click', ->
        self.picture_src = $('.picture img').attr("src")
        self.render_next()

    render: ->
      @$img_tag.attr("src", @picture_url)

    render_next: ->
      self = @
      self.picture_url = self.picture_src

      if self.picture_url == self.picture_src
        next = $(".thumbs").find("[data-big-picture='" + self.picture_src + "']").next().data('big-picture')
        if next
          @$img_tag.attr("src", next)
        else
          @$img_tag.attr("src", self.$thumbs.eq(0).data("big-picture"))
      



  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new PictureViewer @, options
       

