do ($ = jQuery, window, document) ->

  # Create the defaults once
  pluginName = "tabs"
  defaults =
    index: 0

  # The actual plugin constructor
  class Tabs
    constructor: (element, options) ->
      @$element = $(element)
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      self = @
      @id = @$element.data('id')
      @$tabs = @$element.find('.tab-switch')
      @$content = $('div.tabs[data-id="' + @id + '"]')

      @$tabs.on 'click', (e) ->
        e.preventDefault()
        self.settings.index = $(@).index()
        self.render()

      @render()

    render: ->
      @$tabs.removeClass('active').eq(@settings.index).addClass 'active'
      @$content.find('.tab').hide().eq(@settings.index).show()

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    @each ->
      unless $.data @, "plugin_#{pluginName}"
        $.data @, "plugin_#{pluginName}", new Tabs @, options
       
