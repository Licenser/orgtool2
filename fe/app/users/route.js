import Ember from 'ember';

// var get = Ember.get;
// var set = Ember.set;

export default Ember.Route.extend({
  model: function() {
    return this.store.findAll("user");
  },
  afterModel: function(model, transition) {
    model.forEach(function(user) {
      user.reload();
    });
  },
});
