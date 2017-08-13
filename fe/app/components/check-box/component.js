import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
//   classNames: ['check-box'],
  classNameBindings: ['compClasses'],
  canedit: true,

  compClasses: function() {
    if (!this.get('canedit')) {
      return "check-box-disabled";
    }
    return "check-box";
  }.property("canedit"),

  click: function() {
    if (this.get('canedit')) {
      set(this, "value", !get(this, "value"));
    }
  },
});
