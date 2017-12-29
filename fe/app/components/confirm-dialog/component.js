import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['confirm-dialog'],
  showDialog: false,
  msg: { "type": "", "title": "", "content": "" },

//   setup: Ember.on('init', function() {
//     var msg = get(this, "msg");
//     Ember.Logger.debug(">>> msg", msg);
//   }),

  capitalizeFirstLetter: function(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  },

  checkLength: function(val) {
//     if (typeof val === 'string' || val instanceof String) {
//       return val.length > 30 ? "no long" : val;
//     }
    return val;
  },

  changelist: Ember.computed("msg.item", function() {
    var ret = Ember.A()
    if (get(this, "msg.item")) {
      var cs = get(this, "msg.item").changedAttributes();
      var keys = Object.keys(cs);
      for (var key in cs) {
        if (Array.isArray(cs[key]) && cs[key].length == 2) {
          ret.pushObject({name: this.capitalizeFirstLetter(key), was: this.checkLength(cs[key][0]), is: this.checkLength(cs[key][1])});
        } else {
          console.debug(">>>> KEY not handed", key, cs[key]);
        }
     }
    }
    return ret;
  }),

  actions: {
    close: function() {
      this.set("showDialog", false);
    },

    submitConfirm: function() {
      this.get('onConfirm')(get(this, "msg"));
    },
  }
});
