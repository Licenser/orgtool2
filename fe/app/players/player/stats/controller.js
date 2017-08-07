import Ember from 'ember';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  playerManager: Ember.inject.service('player-manager'),
  session: Ember.inject.service('session'),

  grouped: Ember.computed('model', 'model.rewards', function() {
//     console.debug(">>>> setup GROUPS")
    var types = this.store.peekAll("rewardType");
    if (Ember.isEmpty(types)) {
      return [];
    }
    var temp = types.toArray().sort(function(a, b) {
      return Ember.compare(get(a, 'numericLevel'), get(b, 'numericLevel'));
    });

    var group = []; //Ember.A();
    var rt_lookup = [];
    var idx = 0;

    temp.forEach(function(t) {
      group.push({id: get(t, "id"), name: get(t, "name"), rewards: []});
      rt_lookup[get(t, "id")] = idx;
      idx++;
    });

    var self = this;
    get(this, 'model').get("rewards").forEach(function(nrew) {
        if (!Ember.isEmpty(get(nrew, "rewardType.id"))) {
          var gidx = rt_lookup[get(nrew, "rewardType.id")];
          var nr = {id: get(nrew, "id"), name: get(nrew, "name"), img: get(nrew, "img"), units: []};
          group[gidx].rewards.push(nr);
        }
    });

    return group;
  }),

  actions: {
    rewardPlayer: function(reward) {
      var player = get(this, "model");
      get(player, "rewards").pushObject(reward);
      player.save().then(function(done) {
//         debug("saved....", get(done, "id"));
//         player.reload();
      }).catch(function(err) {
        debug("player reward save failed, err", err);
      });
    },

    applyMember: function(unit) {
//       Ember.Logger.debug("apply mem to unit", get(this, "model.name"), unit);
      this.get('playerManager').assign( { 'id': get(this, "model.id"), 'type': 'player', 'dest': unit, 'destType': "applicants" });
    },

    unassignMember: function(player, unit) {
      Ember.Logger.debug("unassign mem from unit");
    },

    showConfirm: function(unit, type) {
      set(this, "msg", { "type": "delete", "item": { unit: unit, type: type}, "title": "Leave Unit?", "content": "Do you really want to leave the unit " + unit.get("name") + "?" });
      set(this, "showConfirmDialog", true);
    },

    onConfirmed: function(msg) {
      var struct = get(msg, "item");
      var element = struct.unit
      var typename = element.get('constructor.modelName');
//       Ember.Logger.debug("element", typename, "===", element);
      this.get('playerManager').unassign({ 'player': get(this, "model"), 'unit': element, 'type': struct.type });
      set(this, "showConfirmDialog", false);
    },
  },
});
