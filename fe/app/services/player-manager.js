import Ember from 'ember';
import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Service.extend({
  ajax: Ember.inject.service(),
  store: Ember.inject.service(),
  session: Ember.inject.service(),
  onePositionPerUnit: true,

  init: function() {
    this._super(...arguments);
  },

  assign: function(data) {
    if (data.type == "player") {
      this.assignPlayer(data);
    } else if (data.type == "ship") {
      this.assignShip(data);
    }
  },

  assignShip: function(data) {
    var store = Ember.get(this, "store");
    var self = this;
    store.findRecord('ship', data.id).then(function(ship) {
      store.findRecord('unit', data.dest).then(function(unit) {
        ship.set('unit', unit);
        ship.save().then(function(un) {
          self.get("session").log("assign", "ship " + ship.get("name") + " to unit " + unit.get("name"));
        }).catch(function(err) {
          console.debug("ERROR", err);
        });
      });
    });
  },

  assignPlayer: function(data) {
    var store = Ember.get(this, "store");
    var self = this;
    store.findRecord('player', data.id).then(function(player) {
      store.findRecord('unit', data.dest).then(function(unit) {
        var leaders = get(player, "leaderships").includes(unit);
        if (data.destType == "leaders" && leaders) {
          return;
        }

        var players = get(player, "playerships").includes(unit);
        if (data.destType == "players" && players) {
          return;
        }

        var applicants = get(player, "applications").includes(unit);
        if (data.destType == "applicants" && applicants) {
          return;
        }

        if (get(self, "onePositionPerUnit")) {
          var rmDest = "";
          if (leaders) {
            rmDest = "leaders";
          }

          if (players) {
            rmDest = "players";
          }

          if (applicants) {
            rmDest = "applicants";
          }

          if (rmDest) {
            unit.get(rmDest).removeObject(player);
          } 
        }

        unit.get(data.destType).pushObject(player).save().then(function(un) {
          self.get("session").log("assign", "player " + player.get("name") + " to unit " + unit.get("name") + " as " + data.destType);
        }).catch(function(err) {
          console.debug("ERROR", err);
        });

      });
    });
  },

  unassign: function(data) {
    var player = data.player;
    var unit = data.unit;
    var type = data.type;

    var mod = false;
    switch (type) {
      case "leader":
        unit.get('leaders').removeObject(player);
        break;
      case "player":
        unit.get('players').removeObject(player);
        break;
      case "applicant":
        unit.get('applicants').removeObject(player);
        break;
    }

    var self = this;
    unit.save().then(function(un) {
      self.get("session").log("unassign", "player " + player.get("name") + " from unit " + unit.get("name") + " as " + type);
    }).catch(function(err) {
      console.debug("ERROR", err);
    });
  },
});
