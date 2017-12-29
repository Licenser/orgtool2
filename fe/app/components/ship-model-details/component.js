import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['item-details'],
  store: Ember.inject.service('session'),
  session: Ember.inject.service('session'),
  item: null,
  listView: false,
  details: false,
  tb: true,
  
  classlist: Ember.computed('item', 'listView', function() {
    var cls = [];
    if (get(this, "listView")) {
      cls.push("ship-model-listview");
    } else {
      cls.push("ship-model-gridview");
    }

    if (get(this, "count") == undefined && get(this, "session.current_user.permission.ship_model_edit")) {
      cls.push("selectable");
    }

    return Ember.String.htmlSafe(cls.join(" "));
  }),

  actions: {
    deleteModel: function(item) {
      this.get('onConfirm')(item);
    },

    editModel: function(item) {
      if (item && this.get('onEdit') && get(this, "session.current_user.permission.ship_model_edit")) {
        this.get('onEdit')(item);
      }
    },
  }
});
