import Ember from 'ember';
// import App from '../../app';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.debug;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  model: null,
  showDialog: true,
  canedit: false,

  def: [
    { name: "read", short: "r" },
    { name: "create", short: "c" },
    { name: "edit", short: "e" },
    { name: "delete", short: "d" }
  ],
  un: [
    { name: "apply", short: "ap" },
    { name: "accept", short: "ac" },
    { name: "assign", short: "as" }
  ],
  sec: [],

  defaultMap: {
    "unit_read": true,
    "unit_create": false,
    "unit_edit": false,
    "unit_delete": false,
    "unit_apply": true,
    "unit_accept": false,
    "unit_assign": false,
    "player_read": true,
    "player_create": false,
    "player_edit": false,
    "player_delete": false,
    "ship_read": true,
    "ship_create": false,
    "ship_edit": false,
    "ship_delete": false,
    "ship_model_read": true,
    "ship_model_create": false,
    "ship_model_edit": false,
    "ship_model_delete": false,
    "reward_read": false,
    "reward_create": false,
    "reward_edit": false,
    "reward_delete": false,
    "user_read": false,
    "user_create": false,
    "user_edit": false,
    "user_delete": false,
  },

  setup: Ember.on('init', function() {
    set(this, "sec", [
      { title: "Units", name: "unit", props: this.def.concat(this.un) },
      { title: "Players", name: "player", props: this.def },
      { title: "Ships", name: "ship", props: this.def },
      { title: "Ship Models", name: "ship_model", props: this.def },
      { title: "Rewards", name: "reward", props: this.def },
      { title: "Users", name: "user", props: this.def }
    ]);

    if (get(this, 'session.current_user.permission.user_edit')) {
      set(this, 'canedit', true);
    }

    console.debug("INIT DONE", get(this, "showDialog"), "|", get(this, 'canedit'));
  }),


  filterdPermissions: function() {
    var canedit = get(this, 'canedit');

    var ret = [];
    var perms = get(this, 'model').get('permission');
    get(this, 'sec').forEach(function(cat, index, obj) {
      var props = [];
      cat.props.forEach(function(p, idx, o) {
        var propname = cat.name + "_" + p.name;
        if (canedit || get(perms, propname)) {
          props.push({name: p.name, propname: propname});
        }
      });

      if (canedit || props.length) {
        ret.push({title: cat.title, name: cat.name, props: props});
      }
    });

    return ret;
  }.property('model'),

  actions: {
    deleteUser:function(user) {
      set(this, "msg", { "type": "delete", "item": user, "title": "Delete User!", "content": "Do you really want to delete user " + user.get("id") + ", " + user.get("name") + "?" });
      set(this, "showConfirmDialog", true);

    },

    onConfirmed: function(msg) {
      if (!msg || !msg.item) {
        return;
      }

      var self = this;
      msg.item.destroyRecord().then(function(done) {
        set(self, "showConfirmDialog", false);
        self.transitionToRoute('users');
      }).catch(function(err) {
        Ember.Logger.debug("delete  user", err);
      });
    },

    saveUser:function(user) {
      var self = this;
      user.save().then(function(data) {
        self.set('showDialog', false);
        self.transitionToRoute('users');
      }).catch(function(err) {
        debug("save error", err);
      });
    },

    checkThemAll: function(state) {
      var perms = get(this, "model").get("permission");
      var def = get(this, "defaultMap");
      get(this, "sec").forEach(function(cat) {
        cat.props.forEach(function(p) {
          var propname = cat.name + "_" + p.name;

          var toSet = state;
          if (state == "default") {
            toSet = def[propname];
          }

          set(perms, propname, toSet);
        });
      });

      set(perms, "active", (state == "default") ? true : state);
    },

    checkAll: function(cat, state) {
      var perms = get(this, "model").get("permission");
      var def = get(this, "defaultMap");
      cat.props.forEach(function(p) {
        var propname = cat.name + "_" + p.name;

        var toSet = state;
        if (state == "default") {
          toSet = def[propname];
        }
        set(perms, propname, toSet);
      });
    },

    close: function() {
//       var model = get(this, 'model');
//       console.debug(">> cahgned", model.changedAttributes());
//       if (get(this, 'model').get('hasDirtyAttributes')) {
//       }
      this.set('showDialog', false);
      this.transitionToRoute('users');
    },

  }
});
