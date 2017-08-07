import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['item-details'],
  store: Ember.inject.service('session'),
  session: Ember.inject.service('session'),
  item: null,
  details: false,
  tb: true,

  actions: {
    deleteModel: function(item) {
      this.get('onConfirm')(item);
    },

    editModel: function(item) {
      this.get('onEdit')(item);
    },
  }
});
