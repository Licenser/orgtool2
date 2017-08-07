import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Route.extend({
  session: Ember.inject.service(),

  beforeModel: function(transition){
    var self = this;
    return this.get('session').loadUser().then(function(result) {
      var target = transition.targetName.split(".")[0];
      if (target !== 'login' && target !== "overview") {
        const session = self.get('session');
        if (!session.current_user) {
          self.transitionTo('overview');
        }
      }
    }).catch(function(err) {
        console.debug("GET SESSION error", err);
    });
  }, 

  actions: {
    willTransition(transition) {
      var target = transition.targetName.split(".")[0];
      if (Ember.isEmpty(get(this, "session.current_user")) && (target == "overview" || target == "login")) {
        return true;
      }

      var perms = get(this, "session.current_user.permission");
      switch(target) {
        case "overview":
            return true;
        case "players":
          if (get(perms, "player_read")) {
            return true;
          }
        case "ship-models":
          if (get(perms, "ship_model_read")) {
            return true;
          }
        case "ships":
          if (get(perms, "ship_read")) {
            return true;
          }
        case "rewards":
          if (get(perms, "reward_read")) {
            return true;
          }
        case "users":
          if (get(perms, "user_read")) {
            return true;
          }
        case "log":
          if (get(perms, "settings")) {
            return true;
          }
      }

      console.debug("permission denied for", transition.targetName ,"!!!");
      transition.abort();
    }
  }

});
