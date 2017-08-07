import DS from 'ember-data';
import Ember from 'ember';
import config from '../config/environment';

export default DS.JSONAPIAdapter.extend({
  session: Ember.inject.service('session'),
  host: config.APP.API_HOST,
  namespace: 'api',
  headers: Ember.computed('session.token', function() {
    return {
      'Authorization': this.get('session.token'),
    };
  }),

  queryRecord(store, type, query) {

    if (query.id && query.recursive && type.modelName == "unit") {
      let url = this.buildURL(type.modelName, null, null, 'queryRecord', null);
      url += "/" + query.id + "?recursive=" + query.recursive;
      return this.ajax(url, 'GET', {});
    } else {
      let url = this.buildURL(type.modelName, null, null, 'queryRecord', query);
      if (this.sortQueryParams) {
        query = this.sortQueryParams(query);
      }
      return this.ajax(url, 'GET', { data: query });
    }
  },

  query(store, type, query) {
    if (query.id && query.recursive && type.modelName == "unit") {
      let url = this.buildURL(type.modelName, null, null, 'query', null);
      url += "/" + query.id + "?recursive=" + query.recursive;

      return this.ajax(url, 'GET', {});
    } else {
      let url = this.buildURL(type.modelName, null, null, 'query', query);

      if (this.sortQueryParams) {
        query = this.sortQueryParams(query);
      }

      return this.ajax(url, 'GET', { data: query });
    }
  },


/*
  shouldReloadRecord: function(store, snapshot) {
    return true;
  },

  shouldReloadAll: function(store, snapshot) {
    return true;
  },

  shouldBackgroundReloadRecord: function(store, snapshot) {
    return false;
  },

  shouldBackgroundReloadAll: function(store, snapshot) {
    return false;
  }
*/
});
