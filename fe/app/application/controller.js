import Ember from 'ember';
import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  ajax: Ember.inject.service(),
  session: Ember.inject.service(),
  store: Ember.inject.service(),
  eventManager: Ember.inject.service('events'),
  classNames: ['strech-tree'],
  showDialog: false,
  showBG: true,

  setup: Ember.on('init', function() {
    this.get('eventManager').on('assign', this.assign.bind(this));
    this.get('eventManager').on('unassign', this.unassign.bind(this));

    this.get("session").log("init", "");

    this.get('eventManager').on('log', this.log.bind(this));
    this.get('eventManager').on('success', this.success.bind(this));
    this.get('eventManager').on('failure', this.failure.bind(this));
  }),

  success: function(text) {
    this.set('unit', null);
    this.set('showDialog', false);
    this.set('loading', false);

    Ember.$(".debug").empty();
    Ember.$(".debug").append(text + ' <i class="fa fa-check text-success"></i>');
  },

  failure: function(text) {
    this.set('loading', false);

    Ember.$(".debug").empty();
    Ember.$(".debug").append('<span class="text-danger">error</span> ' + text + ' <i class="fa fa-close text-danger"></i>');
  },

  log: function(text) {
    Ember.$(".debug").empty();
    Ember.$(".debug").append(text);
  },

  assign: function(data) {
//     console.log("DO IT data", data)

    var self = this;
    return this.store.findRecord('player', data.id).then(function(player) {
//       console.log("find 1", player);
      return self.store.findRecord('unit', data.dest).then(function(unit) {
//         console.log("find 2", unit);
        switch (data.destType) {
        case "path":
        case "player":
          console.log(" -> player")
//           return player.get('playerships').pushObject(unit).save().then(function(np) {
//             console.log(" -> save ok", np)
//           }).catch(function(err) {
//             console.log(" -> err", err);
//              unit.rollback();
//           });

          unit.get('players').pushObject(player).save().then(function(np) {
            console.log(" -> save ok", np)
          }).catch(function(err) {
            console.log(" -> err", err);
//              unit.rollback();
          });
 
//           .catch(function(err) {
//              unit.rollback();
//           });
          break;
        case "leader":
          console.log(" -> leader")

          unit.get('leaders').pushObject(player).save().catch(function(err) {
             unit.rollback();
          });
          break;
        case "applicant":
          console.log(" -> applicants")
          unit.get('applicants').pushObject(player).save().catch(function(err) {
             unit.rollback();
          });
          break;
        }
      

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


  actions: {
    logout: function() {
      var csrf = this.get("session.csrf");
      var prom = this.get('ajax').request('/logout', {
        method: 'POST',
        data: {
          _method: 'delete',
          _csrf_token: csrf
        }
      });

//       var prom = this.get('ajax').del(config.APP.API_HOST + "/logout");
//       console.debug("PROM", prom);
      var self = this;
      prom.then(function(done) {
//         console.debug("PROM done", done);
        console.debug("logout done");
        window.location.href="/";
//         self.transitionToRoute('/');
      }).catch(function(err) {
        console.debug("logout err", err);
        window.location.href="/";
//         self.transitionToRoute('/');
      });
//       Ember.$.ajax(config.APP.API_HOST + "/logout", 'DELETE', {});
    },
  }
});
