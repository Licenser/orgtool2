import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  session: Ember.inject.service(),

  model: function() {
    if (get(this, "session.current_user.permission.unit_read")) {
      return this.store.findAll("unit");
    } else {
     return null;
    }
  },

  afterModel: function(model, transition) {
    if (get(this, "session.current_user.permission.player_read")) {
      this.controllerFor('overview').set('players', this.store.findAll('player'));
    }
  },
});

