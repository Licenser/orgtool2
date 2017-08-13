import Ember from 'ember';
// import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  session: Ember.inject.service(),
  showBG: true,

  actions: {
    logout: function() {
      this.get("session").logout();
    },
  }
});
