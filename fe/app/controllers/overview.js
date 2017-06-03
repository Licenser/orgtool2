import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  session: Ember.inject.service(),
  eventManager: Ember.inject.service('events'),

  showPlayers: false,
  countChildren: true,

  currentUnit: null,
  currentChart: { id: 1 },
  currentLevel: 1,

  columns: [50, 50],
  itemHeight: 80,

  setup: Ember.on('init', function() {
    this.get('eventManager').on('addUnit', this.addUnit.bind(this));
    this.get('eventManager').on('addGame', this.addUnit.bind(this));

    this.get('eventManager').on('editUnit', this.editUnit.bind(this));
    this.get('eventManager').on('deleteUnit', this.deleteUnit.bind(this));

    this.get('eventManager').on('setDetails', this.setDetails.bind(this));

    this.setDetails({ "unitid": 1, "extended": true, "sync": true }); 
  }),


  sumChildren: function(unit) {
    var ships = [];
    var players = [];

    if (get(unit, "ships")) {
      ships = get(unit, "ships").mapBy("id");
    }
    if (get(unit, "leaders")) {
      players = get(unit, "leaders").mapBy("id");
    }
    if (get(unit, "players")) {
      players = players.concat(get(unit, "leaders").mapBy("id"));
    }

    if (get(this, "countChildren") && get(unit, "units")) {
      var self = this;
      var temp = [];
      unit.get("units").forEach(function(cunit) {
        var subres = self.sumChildren(cunit);
        ships = ships.concat(subres.ships);
        players = players.concat(subres.players);
      });
    }

    return {ships: ships, players: players};
  },


  sumThemAll: function() {
    console.debug(">>> SUM THEM ALL");
    var ids = this.sumChildren(get(this, "currentUnit"));
    var shipids = ids.ships.filter(function (ship, pos) {return ids.ships.indexOf(ship) == pos});
    var playerids = ids.players.filter(function (player, pos) {return ids.players.indexOf(player) == pos});


    var store = get(this, "store");
    var self = this;
    // TODO: fix query so you dont have to fetch them
    var fetch = {};
    shipids.forEach(function(shipId) {
      fetch[shipId] = store.findRecord('ship', shipId);
    });
    var allShips = {};
    Ember.RSVP.hash(fetch).then(function(result) {
      console.debug(" SHIP MEGA FETCH DONE", result);
      for (var key in result) {
        var ship = store.peekRecord('ship', key);
        var model = ship.get("ship_model");
        var modelId = ship.get("ship_model.id");
        if (allShips[modelId]) {
          allShips[modelId].count++;
        } else {
          allShips[modelId] = { model: model, count: 1};
        }
      }
      var output = Object.keys(allShips).map(function(key) {
        return {model: allShips[key].model, count: allShips[key].count};
      });

      output.sort(function(a, b) {
        var an = a.model.get('name');
        var bn = b.model.get('name');
        if(an < bn) return -1;
        if(an > bn) return 1;
        return 0;
      });
      set(self, "sumShips", output);
    });

    set(this, "sumPlayers", playerids);
    console.debug(">>> SUM DONE ", shipids, playerids);

  }.observes('currentUnit', 'countChildren'),

  addUnit: function(data) {
    var self = this;
    this.store.findRecord('unit', data.id).then(function (punit) {
      self.store.findRecord('unitType', data.unitType).then(function (unitType) {
        var unit = self.store.createRecord('unit');
        unit.set('unitType', unitType);
        unit.set('unit', punit);
//         get(punit, 'units').pushObject(unit);

        unit.save().then(function(done) {
          debug("done saving", done);
//           self.set('unit', done);
          self.get('eventManager').trigger('rerender');
          self.transitionToRoute('overview.unit', done.get('id'));
        }).catch(function(err) {
          debug("error saving", err);
          unit.deleteRecord();
        });
      });
    });
  },

  editUnit: function(data) {
    this.transitionToRoute('overview.unit', data.id);
  },

  deleteUnit: function(data) {
    var self = this;
    this.store.deleteRecord(data.unit);
    data.unit.save().then(function(nunit) {
      self.get('eventManager').trigger('rerender');
    }).catch(function(err) {
      Ember.Logger.debug("del err", err);
      data.unit.rollback();
      self.get('eventManager').trigger('rerender');
    });
  },


  setDetails: function(data) {
    if (!get(this, "session.current_user.permission.unit_read")) {
      console.debug("nope, go away");
      return;
    }
//     Ember.Logger.log("---- set details", data);
    var unitId = data.unitid;
    var extended = data.extended;
    var sync = data.sync;

//     if (extended && (!this.get('players') || this.get('players.length') === 0)) {
//       this.set('players', this.store.peekAll('player'));
//     }

    if (unitId !== undefined) {
      var self = this;
//       TODO: fix query
//       get(this, 'store').queryRecord('unit', { id: unitId, recursive: true })
      get(this, 'store').query('unit', { id: unitId, recursive: true }).then(function(units) {
        var unit = self.get('store').peekRecord('unit', unitId);

        self.set('extended', extended);
        self.set('currentUnit', unit);
//         self.set('units', units);
        if (sync) {
          self.set('currentChart', unit);
        }
      }).catch(function(err) {
        Ember.Logger.log(">>>>  error ", err);
        self.set('currentUnit', 1);
        self.set('currentChart', 1);
      });
    } else {
      this.set('currentUnit', 1);
      this.set('currentChart', 1);
    }

    if(this.get('currentUnit', 1)) {
      this.set('currentLevel', 1);
    } else {
      this.set('currentLevel', 5);
    }
  },
});
