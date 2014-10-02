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
      @picture_caption = @$thumbs.eq(0).data("caption")

      @$img_tag = @$element.find('.picture img')
      @$caption_tag = @$element.find('.picture .caption')

      @$thumbs.on 'click', ->
        self.picture_url = $(@).data("review")
        self.picture_caption = $(@).data("caption")
        self.render()

      @$img_tag.on 'click', ->
        self.picture_src = $('.picture img').attr("src")
        self.render_next()

    render: ->
      @$img_tag.attr("src", @picture_url)
      @$caption_tag.html(@picture_caption)

    render_next: ->
      self = @
      self.picture_url = self.picture_src

      if self.picture_url == self.picture_src
        next_url = $(".thumbs").find("[data-review='" + self.picture_src + "']").next().data('review')
        next_caption = $(".thumbs").find("[data-review='" + self.picture_src + "']").next().data('caption')
        if next_url
          @$img_tag.attr("src", next_url)
          @$caption_tag.html(next_caption)
        else
          @$img_tag.attr("src", self.$thumbs.eq(0).data("review"))
          @$caption_tag.html(self.$thumbs.eq(0).data("caption"))
      



  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new PictureViewer @, options
       

