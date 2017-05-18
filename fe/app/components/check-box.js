import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['check-box'],

//   setup: Ember.on('init', function() {
//   }),

/*
  size: Ember.computed('bigIcon', function() {
    return get(this, "bigIcon") ? "fa-2x" : "";
  }).property("bigIcon"),
*/
//   size: Ember.computed
//   }.property("bigIcon"),

  click: function() {
    console.debug("clicked...");
    set(this, "value", !get(this, "value"));
  },
});
