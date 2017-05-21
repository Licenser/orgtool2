import Ember from 'ember';

export default Ember.Route.extend({

  redirect: function() {
     Ember.Logger.log(">>> index route >>>> redirect");
    this.transitionTo('overview');
  },

});
