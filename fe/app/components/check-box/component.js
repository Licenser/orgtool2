import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['check-box'],

  click: function() {
    set(this, "value", !get(this, "value"));
  },
});
