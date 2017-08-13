import Ember from 'ember';

var get = Ember.get;

export default Ember.Route.extend({
  session: Ember.inject.service(),

  redirect: function() {
    var perms = get(this, "session.current_user.permission");
    if (Ember.isEmpty(perms)) {
      return;
    }

    var target = "";
    if (get(perms, "unit_read")) {
      target = "overview";
    } else if (get(perms, "player_read")) {
      target = "players";
    } else if (get(perms, "ship_read")) {
      target = "ships";
    } else if (get(perms, "ship_model_read")) {
      target = "ship-models";
    } else if (get(perms, "reward_read")) {
      target = "rewards";
    } else if (get(perms, "user_read")) {
      target = "users";
    }
    if (target) {
      this.transitionTo(target);
    }
  },
});
