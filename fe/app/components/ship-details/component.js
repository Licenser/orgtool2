import Ember from 'ember';
import Drag from 'orgtool/components/drag/component';
var get = Ember.get;
var set = Ember.set;

export default Drag.extend({
  classNames: ['item-details'],
//   store: Ember.inject.service('session'),
//   session: Ember.inject.service('session'),
  details: false,
  listView: false,
  tb: true,
  item: Ember.computed.alias('ship'),
  itemtype: "ship",

  classlist: Ember.computed('ship', 'ship.unit', 'listView', function() {
    var cls = [];
    if (get(this, "listView")) {
      cls.push("ship-model-listview");
    } else {
      cls.push("ship-model-gridview");
    }

    if (this.canModify() && !this.canDrag) {
      cls.push("selectable");
    }

    return Ember.String.htmlSafe(cls.join(" "));
  }),

  canModify: function() {
    return get(this, "count") == undefined &&
            (get(this, "session.current_user.permission.ship_model_edit") ||
             get(this, 'session.current_user.permission.player_edit') ||
             (get(this, 'session.current_user.id') == get(this, 'ship.player.user.id')));
  },

  actions: {
    deleteShip: function(ship) {
      console.debug(">>> DEL SHIP DONE NOTHING here", ship);
//       this.get('onConfirm')(ship);
    },

    editShip: function(ship) {
      if (this.canModify() && this.get('onEdit')) {
//         console.debug(">>> SHOW SHIP", ship);
        this.get('onEdit')(ship);
      }
    },
  }
});
