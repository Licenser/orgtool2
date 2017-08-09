import Ember from 'ember';
// import App from '../../app';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.debug;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  showDialog: false,
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

  setup: Ember.on('init', function() {
//     var perms = get(this, 'session.current_user.permission');
//     var perms = get(this, 'mo.current_user.permission');

    set(this, "sec", [
      { title: "Units", name: "unit", prop: this.def.concat(this.un) },
      { title: "Players", name: "player", prop: this.def },
      { title: "Ships", name: "ship", prop: this.def },
      { title: "Ship Models", name: "ship_model", prop: this.def },
      { title: "Rewards", name: "reward", prop: this.def },
      { title: "Users", name: "user", prop: this.def }
    ]);
  }),

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

    close: function() {
      this.set('showDialog', false);
      this.transitionToRoute('users');
    },

    checkThemAll: function(state) {
      var perms = get(this, "model").get("permission");
      get(this, "sec").forEach(function(cat) {
        cat.prop.forEach(function(p) {
          var propname = cat.name + "_" + p.name;
          set(perms, propname, state);
        });
      });
      set(perms, "active", state);
    },

    checkAll: function(cat, state) {
      var perms = get(this, "model").get("permission");
      cat.prop.forEach(function(p) {
        var propname = cat.name + "_" + p.name;
        set(perms, propname, state);
      });
    },
  }
});
