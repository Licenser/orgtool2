import Ember from 'ember';
import Drag from 'orgtool/components/drag/component';
import UnitColor from 'orgtool/mixins/unit-color';

var get = Ember.get;
var set = Ember.set;

export default Drag.extend(UnitColor, {
  classNames: ['item-details'],
  details: false,
  listView: false,
  tb: true,
  item: Ember.computed.alias('ship'),
  itemtype: "ship",

  unitStyle: Ember.computed('ship.unit', 'ship.unit.color', function() {
    return this.getColor(this.get("ship.unit"));
  }),

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
