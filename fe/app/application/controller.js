import Ember from 'ember';
import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  ajax: Ember.inject.service(),
  session: Ember.inject.service(),
  store: Ember.inject.service(),
  showBG: true,

  setup: Ember.on('init', function() {
    this.get("session").log("init", "");
  }),

  actions: {
    logout: function() {
      var csrf = this.get("session.csrf");
      var prom = this.get('ajax').request('/logout', {
        method: 'POST',
        data: {
          _method: 'delete',
          _csrf_token: csrf
        }
      });

//       var prom = this.get('ajax').del(config.APP.API_HOST + "/logout");
//       console.debug("PROM", prom);
      var self = this;
      prom.then(function(done) {
//         console.debug("PROM done", done);
        console.debug("logout done");
        window.location.href="/";
//         self.transitionToRoute('/');
      }).catch(function(err) {
        console.debug("logout err", err);
        window.location.href="/";
//         self.transitionToRoute('/');
      });
//       Ember.$.ajax(config.APP.API_HOST + "/logout", 'DELETE', {});
    },
  }
});
