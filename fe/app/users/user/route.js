import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  model: function(params) {
    Ember.Logger.debug("get user", params.user_id);
    return this.store.findRecord('user', params.user_id);
  },

  afterModel: function(model, transition) {
//     var ctrl = this.controllerFor('users.user');
//     ctrl.set('showDialog', true);
//     Ember.Logger.debug("hmm?");
  },
//   setupController: function(controller, model) {
//     Ember.Logger.debug("what");
//     controller.setProperties(model);
//   },

  actions: {
  }
});

