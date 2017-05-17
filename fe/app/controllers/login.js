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
  supportedProviders: [ "identity", "google", "twitter", "slack", "facebook", "github", "microsoft", "discord", "wordpress" ],
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
      if (self.supportedProviders.indexOf(provider) > -1) {
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


  actions: {
    setSignup: function() {
      set(this, "sign", { name: "", email: "", password: "", password_confirmation: "" });
    },

    unsetSignup: function() {
      set(this, "sign", null);
    },

    register: function() {
      get(this, "session").sendRequest(get(this, "sign"));
    },

    login: function() {
      get(this, "session").sendRequest(get(this, "cred"));
    },

    loginProvider: function(provider) {
      window.location.href='auth/' + provider;
    }
  }
});
