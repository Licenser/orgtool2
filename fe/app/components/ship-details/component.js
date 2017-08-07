import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['item-details'],
  store: Ember.inject.service('session'),
  session: Ember.inject.service('session'),
  details: false,
  tb: true,

  actions: {
    deleteShip: function(ship) {
      this.get('onConfirm')(ship);
    },

    editShip: function(ship) {
      this.get('onEdit')(ship);
    },
  }
});
