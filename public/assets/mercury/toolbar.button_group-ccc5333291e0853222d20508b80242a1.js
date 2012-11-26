(function() {

  this.Mercury.Toolbar.ButtonGroup = (function() {

    function ButtonGroup(name, options) {
      this.name = name;
      this.options = options != null ? options : {};
      this.build();
      this.bindEvents();
      this.regions = this.options._regions;
      return this.element;
    }

    ButtonGroup.prototype.build = function() {
      this.element = jQuery('<div>', {
        "class": "mercury-button-group mercury-" + this.name + "-group"
      });
      if (this.options._context || this.options._regions) {
        return this.element.addClass('disabled');
      }
    };

    ButtonGroup.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('region:update', function(event, options) {
        var context, element;
        context = Mercury.Toolbar.ButtonGroup.contexts[_this.name];
        if (context) {
          if (options.region && jQuery.type(options.region.currentElement) === 'function') {
            element = options.region.currentElement();
            if (element.length && context.call(_this, element, options.region.element)) {
              return _this.element.removeClass('disabled');
            } else {
              return _this.element.addClass('disabled');
            }
          }
        }
      });
      Mercury.on('region:focused', function(event, options) {
        if (_this.regions && options.region && options.region.type) {
          if (_this.regions.indexOf(options.region.type) > -1) {
            if (!_this.options._context) {
              return _this.element.removeClass('disabled');
            }
          } else {
            return _this.element.addClass('disabled');
          }
        }
      });
      return Mercury.on('region:blurred', function(event, options) {
        if (_this.options.regions) return _this.element.addClass('disabled');
      });
    };

    return ButtonGroup;

  })();

  this.Mercury.Toolbar.ButtonGroup.contexts = {
    table: function(node, region) {
      return !!node.closest('table', region).length;
    }
  };

}).call(this);
