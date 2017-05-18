import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['item-details'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  details: false,
  tb: true,

/*
  init() {
    this._super(...arguments);
    console.debug(">>>>>>>>>> INIT", get(this, "item.id"));
//     this.errors = [];
  },

  didUpdateAttrs() {
    this._super(...arguments);
    console.debug(">>>>>>>>>> updateAttr", get(this, "item.id"));
//     this.set('errors', []);
  },

  didReceiveAttrs() {
    this._super(...arguments);
//     console.debug(">>>>>>>>>> receivedAttr item details");
    console.debug(">>>>>>>>>> receivedAttr", get(this, "item.id"));
  },

  didInsertElement() {
    this._super(...arguments);
//     this.$().attr('contenteditable', true);
    console.debug(">>>>>>>>>>  didInsertElement", get(this, "item.id"));
  },

  wtf: function() {
    console.debug(">>>>>>>>>>  COMPUTE", get(this, "item.id"));
  }.observes('model'),
*/
  actions: {
    deleteItem: function(item) {
      this.get('onConfirm')(item);
    },

    editItem: function(item) {
      this.get('onEdit')(item);
    },
  }
});
