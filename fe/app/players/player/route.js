import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  model: function(params) {
    var self = this;
    return this.store.findRecord('player', params.player_id).then(function(pl) {
//       console.debug("-- RELOAD HELL --", get(pl, "rewards.length"));
      var fetch = {
        rewardType: self.store.findAll('rewardType')
      };
      pl.get("rewards").forEach(function(reward) {
        fetch[get(reward, "id")] = reward.reload();
      });

//       console.debug("-- RELOAD HELL --", fetch);
      var all = Ember.RSVP.hash(fetch);
      return all.then(function(done) {
//         Ember.Logger.log("-- HELL loaded --");
        return pl;
      });
    });
  },

  afterModel: function(model, transition) {
    this.controllerFor('players.player').set('showDialog', true);
  },

  actions: {
    addHandle: function(player) {
      var handle = this.store.createRecord('handle');
      handle.set('player', player);
      this.controllerFor('players.player').set('currHandle', handle);
      this.controllerFor('players.player').set('showHandleDialog', true);
    },

    editHandle: function(handle) {
      this.controllerFor('players.player').set('currHandle', handle);
      this.controllerFor('players.player').set('showHandleDialog', true);
    },
  }
});

