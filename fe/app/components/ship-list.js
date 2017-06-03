import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-filtered-list'],
  sortProperties: ['numericID'],
  details: false,
  showEdit: false,
  session: Ember.inject.service('session'),
  store: Ember.inject.service('store'),
  gameFilter: null,
  columns: [25, 25, 25, 25],
  itemHeight: 400,
  showFilter: true,

  player: null,
  currShip: null,

  showConfirmDialog: false,
  showShipDialog: false,
  showShipTypeDialog: false,

  adminMode: false,

  loading: false,

  ships: Ember.computed(function() {
    this.set("loading", true);
    var res;

    if (Ember.isEmpty(get(this, "player"))) {
      res = get(this, "store").findAll("ship");
    } else {
      console.log("player")
      res = get(this, "player.ships");
    }

    this.set("loading", false);

    return res;
  }),
  sortedShips: Ember.computed.sort('ships', 'sortDefinition'),
  sortDefinition: ['ship_model_id'],

  resetAll: function() {
    set(this, "currShip", null);
    set(this, "showShipDialog", false);
    set(this, "showConfirmDialog", false);
  },

  actions: {
    setTypeFilter: function(data) {
      set(this, 'typeFilter', data);
    },

    setGameFilter: function(data) {
      set(this, 'gameFilter', data);
    },

    clearFilter: function() {
      this.set('searchFilter', '');
    },

    showConfirm: function(ship) {
      Ember.Logger.debug("show confirm", get(ship, "name"));

      set(this, "msg", { "type": "delete", "item": ship, "title": "Delete ship!", "content": "Do you really want to delete the ship " + ship.get("name") + "?" });
      set(this, "showConfirmDialog", true);
    },

    onConfirmed: function(msg) {
      var element = get(msg, "item");
      var self = this;
      if (element) {
        if (get(msg, "type") == "delete") {
          element.destroyRecord().then(function() {
            get(self, "session").log('ship', element.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not delete ship " + element.get("name"));
            Ember.Logger.debug("error deleting", err);
          }).finally(function() {
            self.resetAll();
          });
        }
      } else {
        self.resetAll();
      }
    },

    showEdit: function(ship) {
      this.set('currShip', ship);
      this.set('showShipDialog', true);
    },

    addShip: function() {
      debug("ADD SHIP");
      var ship = get(this, "store").createRecord('ship');

      if (!Ember.isEmpty(get(this, "player"))) {
        ship.set('player', get(this, "player"));
        get(this, "session").log("ship", "added ship to player " + get(this, "player").get("name"));
      }

      this.set('showShipDialog', true);
      this.set('currShip', ship);
    },
  }

});
