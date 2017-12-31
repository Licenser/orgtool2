import Ember from 'ember';

export default Ember.Mixin.create({
  getColor: function(unit) {
    if (!unit) {
      return "";
    }

    var cstr = unit.get("color");
    var color;


    if (!Ember.isEmpty(cstr)) {
      color = this.hexToRgb(cstr);
    }
    if (!color) {
      cstr = this.getParentColor(unit);
    }

    if (Ember.isEmpty(cstr)) {
      cstr = "#000";
    }

    color = this.hexToRgb(cstr);
    if (!color) {
      color = this.hexToRgb("#000");
    }

    var cont = this.getContrastYIQ(color);
    var contstr = this.rgbToHex(cont);
    return Ember.String.htmlSafe("background: " + cstr + "; color:" + contstr);
  },

   getParentColor: function(unit) {
    try {
      if (unit) {
        if (!Ember.isEmpty(unit.get("color")) && unit.get("color").length > 3) {
          return unit.get("color");
        } else if (unit.get('unit')) {
          return this.getParentColor(unit.get('unit'));
        } else {
        }
      }
    } catch(err) {
        Ember.Logger.debug("error", err);
    }
    return null;
  },

  getContrast50: function (hexcolor){
      return (parseInt(hexcolor, 16) > 0xffffff/2) ? 'black':'white';
  },

  getContrastYIQ: function(color) {
    var yiq = ((color.r*299)+(color.g*587)+(color.b*114))/1000;
    return (yiq >= 128) ? {r:0, g:0, b:0} : {r:255, g:255, b:255};
  },

  hexToRgb: function(hex) {
      // Expand shorthand form (e.g. "03F") to full form (e.g. "0033FF")
      var shorthandRegex = /^#?([a-f\d])([a-f\d])([a-f\d])$/i;
      hex = hex.replace(shorthandRegex, function(m, r, g, b) {
          return r + r + g + g + b + b;
      });

      var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
      return result ? {
          r: parseInt(result[1], 16),
          g: parseInt(result[2], 16),
          b: parseInt(result[3], 16)
      } : null;
  },

  rgbToHex: function(color) {
      return "#" + ((1 << 24) + (color.r << 16) + (color.g << 8) + color.b).toString(16).slice(1);
  },
});
