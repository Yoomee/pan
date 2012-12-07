(function() {
  var __hasProp = Object.prototype.hasOwnProperty;

  this.Mercury.Toolbar.Button = (function() {

    function Button(name, title, summary, types, options) {
      this.name = name;
      this.title = title;
      this.summary = summary != null ? summary : null;
      this.types = types != null ? types : {};
      this.options = options != null ? options : {};
      if (this.title) this.title = Mercury.I18n(this.title);
      if (this.summary) this.summary = Mercury.I18n(this.summary);
      this.build();
      this.bindEvents();
      return this.element;
    }

    Button.prototype.build = function() {
      var mixed, type, url, _ref, _ref2, _results;
      this.element = jQuery('<div>', {
        title: (_ref = this.summary) != null ? _ref : this.title,
        "class": "mercury-button mercury-" + this.name + "-button"
      }).html("<em>" + this.title + "</em>");
      this.element.data('expander', "<div class=\"mercury-expander-button\" data-button=\"" + this.name + "\"><em></em><span>" + this.title + "</span></div>");
      this.handled = {};
      _ref2 = this.types;
      _results = [];
      for (type in _ref2) {
        if (!__hasProp.call(_ref2, type)) continue;
        mixed = _ref2[type];
        switch (type) {
          case 'preload':
            _results.push(true);
            break;
          case 'regions':
            this.element.addClass('disabled');
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed);
            break;
          case 'toggle':
            _results.push(this.handled[type] = true);
            break;
          case 'mode':
            _results.push(this.handled[type] = mixed === true ? this.name : mixed);
            break;
          case 'context':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed : Mercury.Toolbar.Button.contexts[this.name]);
            break;
          case 'palette':
            this.element.addClass("mercury-button-palette");
            url = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            _results.push(this.handled[type] = new Mercury.Palette(url, this.name, this.defaultDialogOptions()));
            break;
          case 'select':
            this.element.addClass("mercury-button-select").find('em').html(this.title);
            url = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            _results.push(this.handled[type] = new Mercury.Select(url, this.name, this.defaultDialogOptions()));
            break;
          case 'panel':
            this.element.addClass('mercury-button-panel');
            url = jQuery.isFunction(mixed) ? mixed.call(this, this.name) : mixed;
            this.handled['toggle'] = true;
            _results.push(this.handled[type] = new Mercury.Panel(url, this.name, this.defaultDialogOptions()));
            break;
          case 'modal':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.apply(this, this.name) : mixed);
            break;
          case 'lightview':
            _results.push(this.handled[type] = jQuery.isFunction(mixed) ? mixed.apply(this, this.name) : mixed);
            break;
          default:
            throw Mercury.I18n('Unknown button type \"%s\" used for the \"%s\" button.', type, this.name);
        }
      }
      return _results;
    };

    Button.prototype.bindEvents = function() {
      var _this = this;
      Mercury.on('button', function(event, options) {
        if (options.action === _this.name) return _this.element.click();
      });
      Mercury.on('mode', function(event, options) {
        if (_this.handled.mode === options.mode && _this.handled.toggle) {
          return _this.togglePressed();
        }
      });
      Mercury.on('region:update', function(event, options) {
        var element;
        if (_this.handled.context && options.region && jQuery.type(options.region.currentElement) === 'function') {
          element = options.region.currentElement();
          if (element.length && _this.handled.context.call(_this, element, options.region.element)) {
            return _this.element.addClass('active');
          } else {
            return _this.element.removeClass('active');
          }
        } else {
          return _this.element.removeClass('active');
        }
      });
      Mercury.on('region:focused', function(event, options) {
        if (_this.handled.regions && options.region && options.region.type) {
          if (_this.handled.regions.indexOf(options.region.type) > -1) {
            return _this.element.removeClass('disabled');
          } else {
            return _this.element.addClass('disabled');
          }
        }
      });
      Mercury.on('region:blurred', function() {
        if (_this.handled.regions) return _this.element.addClass('disabled');
      });
      this.element.on('mousedown', function() {
        return _this.element.addClass('active');
      });
      this.element.on('mouseup', function() {
        return _this.element.removeClass('active');
      });
      return this.element.on('click', function(event) {
        var handled, mixed, type, _ref;
        if (_this.element.closest('.disabled').length) return;
        handled = false;
        _ref = _this.handled;
        for (type in _ref) {
          if (!__hasProp.call(_ref, type)) continue;
          mixed = _ref[type];
          switch (type) {
            case 'toggle':
              if (!_this.handled.mode) _this.togglePressed();
              break;
            case 'mode':
              handled = true;
              Mercury.trigger('mode', {
                mode: mixed
              });
              break;
            case 'modal':
              handled = true;
              Mercury.modal(_this.handled.modal, {
                title: _this.summary || _this.title,
                handler: _this.name
              });
              break;
            case 'lightview':
              handled = true;
              Mercury.lightview(_this.handled.lightview, {
                title: _this.summary || _this.title,
                handler: _this.name,
                closeButton: true
              });
              break;
            case 'palette':
            case 'select':
            case 'panel':
              event.stopPropagation();
              handled = true;
              _this.handled[type].toggle();
          }
        }
        if (!handled) {
          Mercury.trigger('action', {
            action: _this.name
          });
        }
        if (_this.options['regions'] && _this.options['regions'].length) {
          return Mercury.trigger('focus:frame');
        }
      });
    };

    Button.prototype.defaultDialogOptions = function() {
      return {
        title: this.summary || this.title,
        preload: this.types.preload,
        appendTo: this.options.appendDialogsTo || 'body',
        closeButton: true,
        "for": this.element
      };
    };

    Button.prototype.togglePressed = function() {
      return this.element.toggleClass('pressed');
    };

    return Button;

  })();

  this.Mercury.Toolbar.Button.contexts = {
    backColor: function(node) {
      return this.element.css('background-color', node.css('background-color'));
    },
    foreColor: function(node) {
      return this.element.css('background-color', node.css('color'));
    },
    bold: function(node) {
      var weight;
      weight = node.css('font-weight');
      return weight === 'bold' || weight > 400;
    },
    italic: function(node) {
      return node.css('font-style') === 'italic';
    },
    overline: function(node) {
      var parent, _i, _len, _ref;
      if (node.css('text-decoration') === 'overline') return true;
      _ref = node.parentsUntil(this.element);
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        parent = _ref[_i];
        if (jQuery(parent).css('text-decoration') === 'overline') return true;
      }
      return false;
    },
    strikethrough: function(node, region) {
      return node.css('text-decoration') === 'line-through' || !!node.closest('strike', region).length;
    },
    underline: function(node, region) {
      return node.css('text-decoration') === 'underline' || !!node.closest('u', region).length;
    },
    subscript: function(node, region) {
      return !!node.closest('sub', region).length;
    },
    superscript: function(node, region) {
      return !!node.closest('sup', region).length;
    },
    justifyLeft: function(node) {
      return node.css('text-align').indexOf('left') > -1;
    },
    justifyCenter: function(node) {
      return node.css('text-align').indexOf('center') > -1;
    },
    justifyRight: function(node) {
      return node.css('text-align').indexOf('right') > -1;
    },
    justifyFull: function(node) {
      return node.css('text-align').indexOf('justify') > -1;
    },
    insertOrderedList: function(node, region) {
      return !!node.closest('ol', region.element).length;
    },
    insertUnorderedList: function(node, region) {
      return !!node.closest('ul', region.element).length;
    }
  };

}).call(this);
