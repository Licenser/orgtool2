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
      { name: "user", prop: this.def },
      { name: "player", prop: this.def },
      { name: "unit", prop: this.def.concat(this.un) },
      { name: "ship_model", prop: this.def },
      { name: "ship", prop: this.def },
      { name: "reward", prop: this.def }
    ]);
  }),

//   changed: function() {
//     console.debug(">>> user changed", get(this, "model"), get(this, "model.length"));

//     var self = this;
//     get(this, "store").findRecord("permission", get(this, "model.permission.id")).then(function(perm) {
//       debug("--- set permi fix");
//       self.set("perm", perm);
//     });
//   }.observes('model'),

  actions: {
    deleteUser:function(user) {
//       get(this, 'onConfirm')(user);
      Ember.Logger.debug("delete user now", user);
      set(this, "msg", { "type": "delete", "item": user, "title": "Delete User!", "content": "Do you really want to delete user " + user.get("id") + ", " + user.get("name") + "?" });
      set(this, "showConfirmDialog", true);

    },

    onConfirmed: function(msg) {
//       Ember.Logger.debug("on confirm del mem", msg, " - ", get(msg, "item"));
      if (!msg || !msg.item) {
        return;
      }
      Ember.Logger.debug("delete user");
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
//       Ember.Logger.debug("the other close...");
      this.set('showDialog', false);
        this.transitionToRoute('users');
//       this.transitionToRoute('players');
    }
  }
});
