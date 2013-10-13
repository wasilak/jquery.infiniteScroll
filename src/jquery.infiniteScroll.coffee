# Infinity Scroll plugin
# By Piotr Wasilewski
# wasil.org

# .centerLoading {
#     background: #f3efeb url('../images/loader.gif') no-repeat center !important;
# }

  # Reference jQuery
  $ = jQuery

  # Adds plugin object to jQuery
  $.fn.extend
    # Change pluginName to your plugin's name.
    infiniteScroll: (options) ->
      # Default settings
      settings =
        # These are the defaults.
        element: "tr:last" # default element in parent object (i.e.table) which triggers data loading
        url: ""  # url for AJAX request
        method: "POST" # default request method,
        page: 1
        dataType: "html"
        params: {}  # if needed, params, which have to be passed to AJAX request

      # Merge default settings with options.
      settings = $.extend settings, options

      # some internal vars
      contentHeight = this.height();
      pageHeight = document.documentElement.clientHeight;
      triggerHeight = 0;
      lock = 0;

      # getting content via AJAX
      return @each ()->
        me = $(this)
        console.log settings.url
        idHolder = new Date().getTime()

        # adding div for loader
        me.after('<div id="loader_' + idHolder + '" style="height:80px;background-color: transparent !important"></div>')

        # adding div for holding HTML to-be-attached
        me.after('<div id="' + idHolder + '"></div>')

        window.onscroll = (e)->

          # calculating height triggering loader
          triggerHeight = contentHeight - pageHeight - $(this).scrollTop()

          # if we get to bottom of parent element and there is no lock we can make AJAX request
          # lock prevents multiple simulatanous request and further requests after last empty
          if triggerHeight < 0 and 0 == lock

            # locking AJAX, it will have to be unlocked later on in order to repeat request
            lock = 1;

            # incrementing page
            settings.page += 1;

            ajax = $.ajax
              type: settings.method
              url: settings.url
              dataType: settings.dataType
              data: {page: settings.page}
              beforeSend: ->
                $('#'+'loader_' + idHolder).addClass('centerLoading')
              complete: ->
                $('#'+'loader_' + idHolder).removeClass('centerLoading')
              success: (resp)->
                # console.log resp
                $('#'+idHolder).html(resp).children().hide().appendTo(me).fadeIn(1000)
                $('#'+idHolder).html('')

                # in order to stop further requests
                if '' != resp
                  lock = 0

                contentHeight = me.height()
