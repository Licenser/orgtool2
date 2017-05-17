import Ember from 'ember';
import config from '../config/environment';
import {isAjaxError, isNotFoundError, isForbiddenError} from 'ember-ajax/errors';
import raw from 'ember-ajax/raw';


var get = Ember.get
var set = Ember.set
var debug = Ember.Logger.log

export default Ember.Controller.extend({
  session: Ember.inject.service(),
  ajax: Ember.inject.service(),
  cred: { email: "", password: "" },
  error: null,
  supporedProviders: [ "identity", "google", "twitter", "slack", "facebook", "github", "microsoft", "discord", "wordpress" ],
  identity: false,
  providers: [],

  setup: Ember.on('init', function() {
    var provs = this.get('session.providers');
    if (Ember.isEmpty(provs)) {
      provs = ['identity'];
//       TODO: return?
//       return "";
    }
    var index = provs.indexOf("identity");
    if (index > -1) {
      provs.splice(index, 1);
      set(this, "identity", true);
    }

    var providers = [];
    var self = this;
    provs.forEach(function(provider) {
      if (self.supporedProviders.indexOf(provider) > -1) {
        var icon = self.getIcon(provider);
        providers.push({name: provider, icon: icon });
      }
    });
    set(this, "providers", providers);

  }),

  getIcon: function(provider) {
    switch (provider) {
      case "google": return "google-plus-square";
      case "github": return "github-square";
      case "facebook": return "facebook-square";
      case "slack": return "slack";
      case "twitter": return "twitter-square";
      case "microsoft": return "windows";
      case "discord": return "comments";
      case "wordpress": return "wordpress";
    }
    return "question-circle";
  },


  sendRequest: function(data) {
    data['_csrf_token'] = this.get('session.csrf');
    var prom = this.get('ajax').request('/auth/identity/callback', {
      method: 'POST',
      data: data
    });

//     var prom = raw("/auth/identity/callback", { method: 'POST', data: data });
    // `result` is an object containing `response` and `jqXHR`, among other items
//     return result;

    var self = this;
    prom.then(function() {
//       console.debug("login done");
      window.location.href="/";
    }).catch(function(error) {
      window.location.href="/";
    });
  },

  actions: {
    setSignup: function() {
      set(this, "sign", { name: "", email: "", password: "", password_confirmation: "" });
    },

    unsetSignup: function() {
      set(this, "sign", null);
    },

    register: function() {
      this.sendRequest(get(this, "sign"));
    },

    login: function() {
      this.sendRequest(get(this, "cred"));
    },

    loginProvider: function(provider) {
      window.location.href='auth/' + provider;
    }
  }
});
