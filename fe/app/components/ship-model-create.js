import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['ship-model-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),

  showDialog: false,

  requiredFields: true,
  manufacturers: ["Anvil", "Kruger", "Aegis", "Drake", "RSI", "Crusader", "Origin", "MISC", "Consolidated_outland", "Banu", "Argo_Blue", "Xian", "Vanduul"],

  actions: {
    setManufacturer: function(cat) {
      set(this, "ship_model.manufacturer", cat);
    },

    deleteModel: function(ship_model) {
      this.get('onConfirm')(ship_model);
    },

    saveModel: function(model) {
      debug("save model")
      var self = this;
      if (model) {
        model.save().then(function(nship_model) {
          self.set('ship_model', null);
          self.set('showDialog', false);
          get(self, "session").log("ship_model", "ship_model " + nship_model.get("name") + " saved");
        }).catch(function(err) {
          get(self, "session").log("error", "could not save ship_model " + model.get("name"));
          Ember.Logger.debug("error saving", err);
          self.set('showDialog', true);
        });
      }
    },

    close: function() {
      var ship_model = get(this, 'ship_model');
      var self = this;
      if (!Ember.isEmpty(ship_model)) {
        if (!Ember.isEmpty(ship_model.get("id"))) {
          ship_model.reload();
        } else if (ship_model.get("isNew")) {
          var self = this;
          ship_model.destroyRecord().then(function(nship_model) {
            get(self, "session").log("ship_model", "ship_model " + nship_model.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not save ship_model " + ship_model.get("name"));
            Ember.Logger.debug("error deleting ship_model", err);
          });
        }
      }
      this.set('showDialog', false);
      this.set('ship_model', null);
    },
  }
});
