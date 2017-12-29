import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['handle-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),

  showDialog: false,

  types: [
      { type: "rsi", desc: "RSI", img: "https://robertsspaceindustries.com/media/tb6ui8j38wwscr/icon/RSI.png" },
      { type: "discord", desc: "Discord", img: "http://vignette3.wikia.nocookie.net/siivagunner/images/9/9f/Discord_icon.svg" },
      { type: "steam", desc: "Steam", img: "http://icons.iconarchive.com/icons/martz90/circle/24/steam-icon.png" },
      { type: "custom", desc: "Custom", img: "" },
  ],

  setup: Ember.on('init', function() {
  }),

  canModify: Ember.computed('model', function() {
      Ember.Logger.debug("CAM N Nw  CAN MODIFY");
      return (get(this, 'session.current_user.permission.player_edit') ||
              (get(this, 'session.current_user.id') && get(this, 'model.user.id')));
  }),

  actions: {
    setType: function(type) {
      var handle = get(this, "handle");
      if (handle) {
        Ember.Logger.debug("set type", type.type, "-", type);
  //       Ember.Logger.debug("set type", type);
        set(handle, "typename", type.type);
      }
    },

    saveHandle: function() {
      var handle = get(this, "handle");
      if (handle) {
        var self = this;
        handle.save().then(function(nhandle) {
          self.set('handle', null);
          self.set('showDialog', false);
          get(self, "session").log("handle", "handle " + nhandle.get("type") + " saved");
        }).catch(function(err) {
          get(self, "session").log("error", "could not save handle " + handle.get("type"));
          Ember.Logger.debug("error saving", err);
          self.set('showDialog', true);
        });
      }
    },

    
    deleteHandle: function() {
      var handle = get(this, "handle");
      if (handle) {
        var self = this;
        handle.destroyRecord().then(function() {
          self.set('handle', null);
          self.set('showDialog', false);
          get(self, "session").log("handle", "handle deleted");
        }).catch(function(err) {
          get(self, "session").log("error", "could not delete handle " + handle.get("type"));
          Ember.Logger.debug("error saving", err);
          self.set('showDialog', true);
        });
      }
    },

    close: function() {
      this.set('showDialog', false);
      this.set('handle', null);
    },
  }
});
