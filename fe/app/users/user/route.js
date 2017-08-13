import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  model: function(params) {
    return this.store.findRecord('user', params.user_id);
  },

  afterModel: function(model, transition) {
    var ctrl = this.controllerFor('users.user');
    set(ctrl, "showDialog", true);
  },
});

