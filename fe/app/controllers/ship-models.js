import Ember from 'ember';


var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Controller.extend({
  classNames: ['item-filtered-list'],
  sortProperties: ['numericID'],
  details: false,
  showEdit: false,
  session: Ember.inject.service('session'),

  store: Ember.inject.service(),

  columns: [16.6, 16.6, 16.6, 16.6, 16.6, 16.6],
  itemHeight: 140,

  showFilter: true,


  showConfirmDialog: false,
  showModelDialog: false,
  showModelTypeDialog: false,

  models: Ember.computed(function() {
    this.set("loading", true);
    var res;

    res = get(this, "store").findAll("ship_model");

    this.set("loading", false);

    return res;
  }),

  showConfirm: function(model) {
    Ember.Logger.debug("show confirm", get(model, "name"));

    set(this, "msg", { "type": "delete", "item": model, "title": "Delete model!", "content": "Do you really want to delete the model " + model.get("name") + "?" });
    set(this, "showConfirmDialog", true);
  },

  resetAll: function() {
    set(this, "currModel", null);
    set(this, "showModelDialog", false);
    set(this, "showConfirmDialog", false);
  },

  actions: {
    setTypeFilter: function(data) {
      set(this, 'typeFilter', data);
    },

    clearFilter: function() {
      this.set('searchFilter', '');
    },

    showConfirm: function(model) {
      Ember.Logger.debug("show confirm", get(model, "name"));

      set(this, "msg", { "type": "delete", "item": model, "title": "Delete model!", "content": "Do you really want to delete the model " + model.get("name") + "?" });
      set(this, "showConfirmDialog", true);
    },

    onConfirmed: function(msg) {
      var element = get(msg, "item");
      var self = this;
      if (element) {
        if (get(msg, "type") == "delete") {
          element.destroyRecord().then(function() {
            get(self, "session").log('model', element.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not delete model " + element.get("name"));
            Ember.Logger.debug("error deleting", err);
          }).finally(function() {
            self.resetAll();
          });
        }
      } else {
        self.resetAll();
      }
    },

    showEdit: function(model) {
      this.set('currModel', model);
      this.set('showModelDialog', true);
    },

    addModel: function() {
      debug("ADD Model");
      var model = get(this, "store").createRecord('ship_model');

      this.set('showModelmDialog', true);
      this.set('currModel', model);
    },
  },

});
