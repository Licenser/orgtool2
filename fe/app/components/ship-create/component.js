import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  ship: null,

  manufacturers: ["Anvil", "Kruger", "Aegis", "Drake", "RSI", "Crusader", "Origin", "MISC", "Consolidated_outland", "Banu", "Argo_Blue", "Xian", "Vanduul", "Tumbril_logo"],

  setup: Ember.on('init', function() {
    var self = this;

    get(this, 'store').findAll('ship-model').then(function(ship_models) {
      self.set('ship_models', ship_models);
    });
  }),

  isEmpty: function(obj) {
    return Object.keys(obj).length === 0;
  },

  isModified: Ember.computed('ship.hasDirtyAttributes', 'ship.player', 'ship.unit', function() {
    return get(this, 'ship.hasDirtyAttributes') || !this.isEmpty(get(this, 'ship').changedAttributes());
  }),

  canModify: Ember.computed('currentListFilter', function() {
    var ret = get(this, 'session.current_user.can_modify_ship');
    if (!ret && get(this, 'ship')) {
      ret = ret || (get(this, 'session.current_user.permission.player_edit') ||
                    (get(this, 'session.current_user.id') && get(this, 'ship.player.user.id')));
    }
    return ret;
  }),

  actions: {
    changeOwner: function(owner) {
      var ship = get(this, "ship");
      set(ship, "player", owner);
    },

    unassignFromUnit: function(unitid) {
      var ship = get(this, "ship");
      ship.set("unit", null);
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

    deleteShip: function() {
      var ship = get(this, "ship");
      if (ship) {
        this.get('onConfirm')(ship);
      }
    },

    saveShip: function() {
      var ship = get(this, "ship");
      if (ship) {
        var self = this;
        ship.save().then(function(nship) {
          self.set('ship', null);
          self.set('showDialog', false);
          get(self, "session").log("ship", "ship " + nship.get("name") + " saved");
          ship.reload();
        }).catch(function(err) {
          get(self, "session").log("error", "could not save ship " + ship.get("name"));
          Ember.Logger.log("error saving", err);
          self.set('showDialog', true);
        });
      }
    },
    close: function() {
      var ship = get(this, 'ship');
      var doit = true;
      if (ship) {
//         console.debug(">>> CHECK 2",  get(this, 'ship.hasDirtyAttributes'),  " || ", !this.isEmpty(get(this, 'ship').changedAttributes()));
//         console.debug(">>>>", ship.get("hasDirtyAttributes"), " | ", ship.changedAttributes(), "===", this.get("isModified"));
        if (ship.get("hasDirtyAttributes") || !this.isEmpty(ship.changedAttributes())) {
          console.debug("ask tbefore close");
          this.get('onDiscard')(ship);
          doit = false;
        } else {
        }
      }

      if (doit) {
        this.set('ship', null);
        this.set('showDialog', false);
      }


//         if (!Ember.isEmpty(ship.get("id"))) {
//           ship.reload();
//         } else if (ship.get("isNew")) {
//           var self = this;
//           ship.destroyRecord().then(function() {
//             get(self, "session").log("ship", "ship " + ship.get("name") + " deleted");
//           }).catch(function(err) {
//             get(self, "session").log("error", "could not save ship " + ship.get("name"));
//             Ember.Logger.debug("error deleteing ship", err);
//           });
//         }
//       }
//       this.set('ship', null);
//       this.set('showDialog', false);
    },
  }

});
