(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  this.Mercury.Toolbar.Expander = (function(_super) {

    __extends(Expander, _super);

    function Expander(name, options) {
      this.name = name;
      this.options = options;
      this.container = this.options["for"];
      this.containerWidth = this.container.outerWidth();
      Expander.__super__.constructor.call(this, null, this.name, this.options);
      return this.element;
    }

    Expander.prototype.build = function() {
      var _ref;
      this.container.css({
        whiteSpace: 'normal'
      });
      this.trigger = jQuery('<div>', {
        "class": 'mercury-toolbar-expander'
      }).appendTo((_ref = jQuery(this.options.appendTo).get(0)) != null ? _ref : 'body');
      this.element = jQuery('<div>', {
        "class": "mercury-palette mercury-expander mercury-" + this.name + "-expander",
        style: 'display:none'
      });
      return this.windowResize();
    };

    Expander.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('hide:dialogs', function(event, dialog) {
        if (dialog !== _this) return _this.hide();
      });
      Mercury.on('resize', function() {
        return _this.windowResize();
      });
      Expander.__super__.bindEvents.apply(this, arguments);
      this.trigger.click(function(event) {
        var button, hiddenButtons, _i, _len, _ref;
        event.stopPropagation();
        hiddenButtons = [];
        _ref = _this.container.find('.mercury-button');
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          button = _ref[_i];
          button = jQuery(button);
          if (button.position().top > 5) {
            hiddenButtons.push(button.data('expander'));
          }
        }
        _this.loadContent(hiddenButtons.join(''));
        return _this.toggle();
      });
      return this.element.click(function(event) {
        var button, buttonName;
        buttonName = jQuery(event.target).closest('[data-button]').data('button');
        button = _this.container.find(".mercury-" + buttonName + "-button");
        return button.click();
      });
    };

    Expander.prototype.windowResize = function() {
      if (this.containerWidth > jQuery(window).width()) {
        this.trigger.show();
      } else {
        this.trigger.hide();
      }
      return this.hide();
    };

    Expander.prototype.position = function(keepVisible) {
      var position, width;
      this.element.css({
        top: 0,
        left: 0,
        display: 'block',
        visibility: 'hidden'
      });
      position = this.trigger.offset();
      width = this.element.width();
      if (position.left + width > jQuery(window).width()) {
        position.left = position.left - width + this.trigger.width();
      }
      return this.element.css({
        top: position.top + this.trigger.height(),
        left: position.left,
        display: keepVisible ? 'block' : 'none',
        visibility: 'visible'
      });
    };

    return Expander;

  })(Mercury.Palette);

}).call(this);
