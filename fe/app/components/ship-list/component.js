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

  listView: false,
  loading: false,
  compact: false,

  listFilter: ["Player", "Unit", "Manufacturer", "Model"],
//   currentListFilterResult: 0,
//   currentListFilter: "Player",

  canModify: Ember.computed('currentListFilter', function() {
    var ret = get(this, 'session.current_user.permission.ship_create')
    if (get(this, 'player')) {
      ret = ret || (get(this, 'session.current_user.permission.player_edit') ||
                    (get(this, 'session.current_user.id') && get(this, 'player.user.id')));
    }
    return ret;
  }),

  setup: Ember.on('didInsertElement', function() {
    var self = this;
    get(this, 'store').findAll('ship-model').then(function(ship_models) {
      get(self, 'store').findAll('player').then(function(players) {
//         get(self, 'store').findAll('unit').then(function(units) {
          get(self, 'store').findAll('ship').then(function(ships) {
            if (get(self, 'player')) {
              self.set('ships', get(self, 'player.ships'));
  //             console.debug(">> SETUP SMALL LIST ", get(self, 'ships.length'), "---", get(self, 'player'));
            } else {
              self.set('ships', ships);
  //             console.debug(">> SETUP BIG LIST ", get(self, 'ship.length'));
            }
          });
//         });
      });
    });

    this.set("defcols", this.get("columns"))
    this.set("defhi", this.get("itemHeight"))
  }),

  filterGroup: Ember.computed('ships.length', 'listView', 'currentListFilter', 'showAvailable', 'showAssigned', function() {
    var filter = get(this, "currentListFilter");
    var showAvailable = get(this, "showAvailable");
    var showAssigned = get(this, "showAssigned");

    var res = Ember.A();
    if (get(this, 'listView') == undefined) {
      return {list: res, count: 0};
    }

    var self = this;
    var count = 0;
    var loockup = {};

    if (get(this, 'ships')) {
      get(this, 'ships').forEach(function(ship) {
        if ( !( (showAvailable && !get(ship, "available")) || (showAssigned && Ember.isEmpty(ship.get("unit"))) ) ) {
          if (filter == "Player") {
            self.groupBy(loockup, ship, res, "player", "name", "avatar");
            count += 1;
          } else if (filter == "Manufacturer") {
            self.groupBy(loockup, ship, res, "ship_model", "manufacturer");
            count += 1;
          } else if (filter == "Unit") {
            if (get(ship, "unit")) {
              self.groupBy(loockup, ship, res, "unit", "name", "img");
              count += 1;
            }
          } else if (filter == "Model") {
            self.groupBy(loockup, ship, res, "ship_model", "name");
            count += 1;
          }
        }
      });
    }

    this.$('.item-list').focus();
    return {list: res, count: count};
  }),

  groupBy: function(loockup, ship, arr, target, attr, srcimg) {
    if (get(ship, target) && !get(ship, target + ".isLoaded")) {
      get(ship, target).reload();
    }
    var name = get(ship, target + "." + attr);
    var img;
    if (!srcimg) {
      var mname = get(ship, "ship_model.manufacturer");
      img = get(this, "session.rootURL") + "/images/manufacturers/" + mname + ".png";
    } else {
      img = get(ship, target + "." + srcimg);
    }
    if (!loockup[name]) {
      loockup[name] = {name: name, idx: get(arr, "length")};
      arr.pushObject({name: name, img: img, height: 0, ships: Ember.A()});
    }
    arr.objectAt(loockup[name].idx).ships.pushObject(ship);
    arr.objectAt(loockup[name].idx).height = Math.ceil(arr.objectAt(loockup[name].idx).ships.length / this.get("columns").length) * this.get("itemHeight"); 
  },

/*
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

  sortedShips: Ember.computed.sort('ships', function(a, b) {
    var crew_a = a.get('ship_model.crew'),
        crew_b = b.get('ship_model.crew'),
        man_a = a.get('ship_model.manufacturer'),
        man_b = b.get('ship_model.manufacturer'),
        mname_a = a.get('ship_model.name'),
        mname_b = b.get('ship_model.name'),
        name_a = a.get('name'),
        name_b = b.get('name');

    // Note: 1 and -1 flipped to get reverse sort order aka
    // largest ship first.
    if (crew_a > crew_b) return -1;
    if (crew_a < crew_b) return 1;
    // sort by manufacturer second
    if (man_a > man_b) return 1;
    if (man_a < man_b) return -1;
    // last we sort by name
    if (mname_a > mname_b) return 1;
    if (mname_a < mname_b) return -1;
    // last we sort by name
    if (name_a > name_b) return 1;
    if (name_a < name_b) return -1;
    return 0;
  }),
  //sortDefinition: ['ship_model.crew'],
*/

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

    showDiscard: function(ship) {
      Ember.Logger.debug("show disabled", get(ship, "name"));

      set(this, "msg", { "type": "discard", "item": ship, "title": "Discrad ship changed?", "content": "Do you really want to discrad all the changes of the ship " + ship.get("name") + "?" });
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
        } else if (get(msg, "type") == "discard") {
          element.rollbackAttributes();
          element.reload();
          self.resetAll();
        }
      } else {
        self.resetAll();
      }
    },

    setEdit: function(ship) {
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

    setListView: function(listView) {
      if (listView) {
        set(this, "columns", [100]);
        set(this, "itemHeight", 52);
      } else {
        set(this, "columns", this.get("defcols"));
        set(this, "itemHeight", this.get("defhi"));
      }
      set(this, "listView", listView);
    },

    setListFilter: function(filter) {
      set(this, "currentListFilter", filter);
    },
  }

});
