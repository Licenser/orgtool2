import Ember from 'ember';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  myEvents: Ember.inject.service('events'),
  session: Ember.inject.service('session'),
  showDialog: true,

  canModify: Ember.computed('model', function() {
//       Ember.Logger.debug("CAM N NNNNNNNNNNNNNN  CAN MODIFY");
      return (get(this, 'session.current_user.permission.player_edit') ||
              (get(this, 'session.current_user.id') && get(this, 'model.user.id')));
  }),

  actions: {
    saveAvatar: function() {
    },

    saveMember: function(player) {
      this.get('myEvents').trigger('saveMember', player);

//         Ember.Logger.debug("save player", player.get('id'));

      player.save().then(function(mem) {
        Ember.Logger.debug("save ok", mem);
      }).catch(function(err) {
        Ember.Logger.debug("save not ok", err);
      });
    },

    deleteMember: function(player) {
//       this.get('myEvents').trigger('deleteMember', player);
//
      Ember.Logger.debug("delete user now", player);
      set(this, "msg", { "type": "delete", "item": player, "title": "Delete Member!", "content": "Do you really want to delete player [ id: " + player.get("id") + ", name: '" + player.get("name") + "', ships: " + player.get("ships.length") + " ] ?" });
      set(this, "showConfirmDialog", true);

    },

    onConfirmed: function(msg) {
      Ember.Logger.debug("on confirm del mem", msg, " - ", get(msg, "item"));
      if (!msg || !msg.item) {
        return;
      }
      Ember.Logger.debug("delete user");
//       player.deleteRecord('player'); //this.store.createRecord('player');
      var self = this;
      msg.item.destroyRecord().then(function(done) {
        set(self, "showConfirmDialog", false);
        self.transitionToRoute('players');
      }).catch(function(err) {
        Ember.Logger.debug("delete  user", err);
      });
    },

    close: function() {
      set(this, "showDialog", false);
      if (get(this, 'session.current_user.permission.player_read')) {
        this.transitionToRoute('players');
      } else {
        this.transitionToRoute('index');
      }
    },
  }

});
