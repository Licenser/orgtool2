import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  email: DS.attr(),
  'unfold-level': DS.attr(),
//   inserted_at: DS.attr(),
//   created_at: DS.attr(),
  player: DS.belongsTo('player'),
  permission: DS.belongsTo('permission'),

  loggedIn: false,

  can_modify_player: Ember.computed('permission', 'loggedIn', function() {
    return this.can_modify("player");
  }),

  can_modify_ship: Ember.computed('permission', 'loggedIn', function() {
    return this.can_modify("ship");
  }),

  can_modify_user: Ember.computed('permission', 'loggedIn', function() {
    return this.can_modify("user");
  }),

  can_modify: function(target) {
    var perm = this.get('permission');
      console.debug("perms", perm)
    if (Ember.isEmpty(perm)) {
      console.debug("!!!! no perms")
      return false;
    }

    return perm.get(target + '_create') || perm.get(target + '_edit') || (this.get("loggedIn") && perm.get('active'));
  },
});
