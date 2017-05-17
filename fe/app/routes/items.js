import Ember from 'ember';

export default Ember.Route.extend({
  eventManager: Ember.inject.service('events'),

  model: function() {
    console.debug(" LOAD CATEGORIES");
    return this.store.findAll("category");
  },

  afterModel: function(model, transition) {
    //this.controllerFor('settings.items').set('itemTypes', this.store.findAll('itemType'));
  },

});
