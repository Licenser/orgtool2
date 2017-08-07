import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  ship: null,

  manufacturers: ["Anvil", "Kruger", "Aegis", "Drake", "RSI", "Crusader", "Origin", "MISC", "Consolidated_outland", "Banu", "Argo_Blue", "Xian", "Vanduul"],

  setup: Ember.on('init', function() {
    var self = this;

    get(this, 'store').findAll('ship-model').then(function(ship_models) {
//       debug("ship_models: ", get(ship_models, "length"));
      self.set('ship_models', ship_models);
    });
  }),

  actions: {
    changeOwner: function(owner) {
      var ship = get(this, "ship");
      set(ship, "player", owner);
    },

    unassignFromUnit: function(unitid) {
      var ship = get(this, "ship");
      set(ship, "unit", null);
    },

    assignToUnit: function(unitid) {
      var ship = get(this, "ship");
      var unit = get(this, "store").peekRecord("unit", unitid);
      set(ship, "unit", unit);
    },

    setModel: function(model) {
      console.log(model);
      console.log(get(model, "name"));
      console.log(get(model, "img"));
      set(this, "ship.ship_model", model);
      set(this, "ship.name", get(model, "name"));
      set(this, "ship.img", get(model, "img"));
    },

    saveShip: function() {
      var ship = get(this, "ship");
      if (ship) {
        var self = this;
        ship.save().then(function(nship) {
          self.set('ship', null);
          self.set('showDialog', false);
          get(self, "session").log("ship", "ship " + nship.get("name") + " saved");
        }).catch(function(err) {
          get(self, "session").log("error", "could not save ship " + ship.get("name"));
          Ember.Logger.log("error saving", err);
          self.set('showDialog', true);
        });
      }
    },
    close: function() {
      var ship = get(this, 'ship');
      if (!Ember.isEmpty(ship)) {

        if (!Ember.isEmpty(ship.get("id"))) {
          ship.reload();
        } else if (ship.get("isNew")) {
          var self = this;
          ship.destroyRecord().then(function() {
            get(self, "session").log("ship", "ship " + ship.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not save ship " + ship.get("name"));
            Ember.Logger.debug("error deleteing ship", err);
          });
        }
      }
      this.set('ship', null);
      this.set('showDialog', false);
    },
  }

});
