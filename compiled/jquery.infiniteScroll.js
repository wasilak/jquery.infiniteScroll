// Generated by CoffeeScript 1.6.3
(function() {
  var $;

  $ = jQuery;

  $.fn.extend({
    infiniteScroll: function(options) {
      var contentHeight, lock, pageHeight, settings, triggerHeight;
      settings = {
        element: "tr:last",
        url: "",
        method: "POST",
        page: 1,
        dataType: "html",
        params: {}
      };
      settings = $.extend(settings, options);
      contentHeight = this.height();
      pageHeight = document.documentElement.clientHeight;
      triggerHeight = 0;
      lock = 0;
      return this.each(function() {
        var idHolder, me;
        me = $(this);
        console.log(settings.url);
        idHolder = new Date().getTime();
        me.after('<div id="loader_' + idHolder + '" style="height:80px;background-color: transparent !important"></div>');
        me.after('<div id="' + idHolder + '"></div>');
        return window.onscroll = function(e) {
          var ajax;
          triggerHeight = contentHeight - pageHeight - $(this).scrollTop();
          if (triggerHeight < 0 && 0 === lock) {
            lock = 1;
            settings.page += 1;
            return ajax = $.ajax({
              type: settings.method,
              url: settings.url,
              dataType: settings.dataType,
              data: {
                page: settings.page
              },
              beforeSend: function() {
                return $('#' + 'loader_' + idHolder).addClass('centerLoading');
              },
              complete: function() {
                return $('#' + 'loader_' + idHolder).removeClass('centerLoading');
              },
              success: function(resp) {
                $('#' + idHolder).html(resp).children().hide().appendTo(me).fadeIn(1000);
                $('#' + idHolder).html('');
                if ('' !== resp) {
                  lock = 0;
                }
                return contentHeight = me.height();
              }
            });
          }
        };
      });
    }
  });

}).call(this);
