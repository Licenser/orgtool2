import Ember from 'ember';
import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Service.extend({
  ajax: Ember.inject.service(),
  store: Ember.inject.service(),
  onePositionPerUnit: true,

  init: function() {
    this._super(...arguments);
  },

  assign: function(data) {
    console.log("DO IT data", data)
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

    console.debug("UNASSIGN", get(player, "name"), get(unit, "name"), type);
    switch (type) {
      case "leader":
        unit.get('leaders').removeObject(player);
        unit.save();
        break;
      case "player":
        unit.get('players').removeObject(player);
        unit.save();
        break;
      case "applicant":
        unit.get('applicants').removeObject(player);
        unit.save();
        break;
    }
/*
    var units = get(player, 'units');
    var found = false;
    var memUn;
    for (var i = 0; i < get(cu, 'length') && !found; i++) {
      var c = cu.objectAt(i);
      if (get(c, 'id') == get(unit, 'id')) {
        found = true;
        memUn = c;
      }
    }

    if (found) {
      var self = this;
      this.get("session").log("unassign", 'unassign player:' + data.id + ' from unit: ' + data.dest);
//       self.set('loading', true);
      memUn.destroyRecord().then(function() {
        self.get("session").log("unassign", "player unassigned " + data.id);
      }).catch(function(err) {
        self.get("session").log("error", "unassigning player " + get(player, 'id'));
        Ember.Logger.debug("unassign err", err);
        memUn.rollback();
      });
    }
    */
  },

});
