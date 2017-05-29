import Ember from 'ember';
import config from '../config/environment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Service.extend({
  ajax: Ember.inject.service(),
  store: Ember.inject.service(),

  isAdmin: false,
  isUser: false,
  user: null,
  loading: true,
  statesDone: 16,
  state: Ember.A(),
  current_user: null,
  jwt: null,
  csrf: null,
  providers: null,

  init: function() {
//     Ember.Logger.log(">>> init >>>> session");
    this._super(...arguments);
//     this.loadUser();
  },

  loadUser: function() {
    var self = this;
    self.set('current_user', null);


      // fix path to assets in wordpress
    var scripts = document.getElementsByTagName("script");
    var filename = "assets/orgtool.js";
    for (var i = 0; i < scripts.length; i++) {
      var src = scripts[i].src;
      if (src.indexOf(filename) > 0) {
        self.set('rootURL', src.substring(0, src.indexOf(filename)));
//         console.debug(">> ROOT URL", self.get("rootURL"));
        break;
      }
    }

    return new Ember.RSVP.Promise(function(resolve, reject) {
      var element = document.querySelector('meta[name="guardian-token"]');
      var token = element && element.getAttribute("content");

      element = document.querySelector('meta[name="csrf-token"]');
      var csrf = element && element.getAttribute("content");

      element = document.querySelectorAll('meta[name="oauth-provider"]');
      var providers = [];
      element.forEach(function(p) {
        providers.push(p.getAttribute("content"));
      });

      self.set("csrf", csrf);
      self.set("providers", providers);
      self.set("token", "Bearer " + token);

      var session = self.parseJwt(token);
      if (config.environment === 'development') {
        session = {"sub": "User:1"};
      }

      if (Ember.isEmpty(session)) {
        Ember.Logger.log(">>> init >>>> NO session");
        self.set('loading', false);
        resolve();
        return;
      }

      if (!Ember.isEmpty(session) && !Ember.isEmpty(get(session, "sub"))) {
        var userid = session.sub.split(':')[1];
//         Ember.Logger.log("find user", userid);
        return self.get('store').findRecord('user', userid).then(function(user) {
//           Ember.Logger.log(" user found", userid);
          set(user, "loggedIn", true);
          set(self, "current_user", user);
          console.log("current_user", user.get("player.id"));

          self.log("session", "logged in as user");
          self.set('loading', false);
          resolve();
        }).catch(function(err) {
          Ember.Logger.log("error, user", userid, "not found, error:", err);
          self.set('loading', false);
          reject();
        });
      } else {
        Ember.Logger.log(">>> init >>>> broken token");
        self.set('loading', false);
        resolve();
      }
    });
  },

  sendRequest: function(data) {
    var url = '/auth/identity/callback'; 
    if (config.environment === 'development') {
      url = config.APP.API_HOST + url;
    }

    if (Ember.isEmpty(data)) {
      data = {};
    }
    data['_csrf_token'] = this.get('csrf');

    var prom = this.get('ajax').request(url, {
      method: 'POST',
      data: data
    });

    var self = this;
    prom.then(function() {
      console.debug("login done");
      window.location.href="/";
    }).catch(function() {
      console.debug("login error");
      window.location.href="/";
    });
  },


  parseJwt: function(token) {
    if (!Ember.isEmpty(token)) {
      var base64Url = token.split('.')[1];
      var base64 = base64Url.replace('-', '+').replace('_', '/');
      return JSON.parse(window.atob(base64));
    }
    return null;
  },

  log: function(comp, msg) {
    var d = new Date();
    var timestamp = d.getMonth() + "/" + d.getDay() + "/" + d.getFullYear() + " " + d.getHours() + " " + d.getMinutes() + ":" + d.getSeconds();
    var log = Ember.get(this, "store").createRecord('log');
    Ember.set(log, "timestamp", timestamp);
    Ember.set(log, "comp", comp);
    Ember.set(log, "msg", msg);
  },
});
