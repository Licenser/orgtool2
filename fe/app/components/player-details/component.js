import Ember from 'ember';
import Drag from 'orgtool/components/drag/component';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Drag.extend({
  classNames: ['player-details'],
  classNameBindings: ['compClasses'],
  store: Ember.inject.service(),
  playerManager: Ember.inject.service('player-manager'),
  session: Ember.inject.service('session'),

  player: null,
  item: Ember.computed.alias('player'),
  itemtype: "player",

  unit: null,
  type: null,

  compClasses: function() {
    if (this.get('canDrag')) {
      return "player-details-draggable";
    } else if (this.get('selectable')) {
      return "player-details-selectable";
    }
    return "";
  }.property('selectable', "canDrag"),

  didRender() {
    this._super(...arguments);
    if (this.get("reload") && this.get("player")) {
      this.set("reload", false);
      this.get("store").findRecord('player', this.get("player.id"));
    }
  },

  mergedUnits: function() {
    var res = Ember.A();
    res.pushObjects(get(this, 'player.leaderships').toArray());
    res.pushObjects(get(this, 'player.playerships').toArray());
    res.pushObjects(get(this, 'player.applications').toArray());
    return res;
  }.property('player.leaderships', 'player.playerships', 'player.applications'),

  actions: {
    unassignMember: function(player, unit, type) {
      this.get('playerManager').unassign({ 'player': player, 'unit': unit, 'type': type });
    },
  },
});
