import Ember from 'ember';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.debug;

export default Ember.Controller.extend({
  session: Ember.inject.service('session'),

  ranks: Ember.computed.filter('model.rewards', function(reward, index, array) {
//     console.debug("GET RANK", get(reward, "name"), get(reward, "rewardType.id"));
    return get(reward, "rewardType.id") == 1;
  }),

  canModify: Ember.computed('model', function() {
      return (get(this, 'session.current_user.permission.player_edit') ||
              (get(this, 'session.current_user.id') && get(this, 'model.user.id')));
  }),

  actions: {
    saveAvatar: function() {
      Ember.Logger.debug("save", get(this, "model").get("avatar"));
      return false;
    },
  }
});
