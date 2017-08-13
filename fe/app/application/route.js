import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  session: Ember.inject.service(),

  beforeModel: function(transition) {
    var self = this;
    var session = this.get('session');
    return session.loadUser().then(function() {
      if (!self.checkTransition(transition)) {
        self.transitionTo('index');
      }
    }).catch(function(err) {
        console.debug("GET SESSION error", err);
    });
  }, 

  checkTransition(transition) {
    var target = transition.targetName.split(".")[0];
    if (target == 'login') {
      return true;
    }

    if (!get(this, "session").loggedInAndActive()) {
      return false
    }

    var perms = get(this, "session.current_user.permission");
    switch(target) {
      case "index":       return true;
      case "overview":    return get(perms, "unit_read");
      case "players":     return true; //get(perms, "player_read");
      case "ship-models": return get(perms, "ship_model_read");
      case "ships":       return get(perms, "ship_read");
      case "rewards":     return get(perms, "reward_read");
      case "users":       return get(perms, "user_read");
      case "log":         return get(perms, "log_read");
    }

    console.debug("Unknown route", transition.targetName ,"!!!");
    return false;
  },

  actions: {
    willTransition(transition) {
      if (!this.checkTransition(transition)) {
        transition.abort();
      }
    }
  }
});
