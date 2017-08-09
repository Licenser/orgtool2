import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  sortProperties: ['numericID'],
  store: Ember.inject.service(),
  session: Ember.inject.service(),
  details: false,

  columns: [100],
  itemHeight: 42,

/////////////////////////////////////

  hasParent: function(id, unit) {
    try {
      return (unit && unit.get("id") == id) || (unit && unit.get('parent') && this.hasParent(id, unit.get('parent')));
    } catch(err) {
        Ember.Logger.debug("error", err);
    }
    return false;
  },

  filteredContent: Ember.computed.filter('model', function(user, index, array) {
    var searchFilter = this.get('searchFilter');
    if (Ember.isEmpty(searchFilter)) {
      return true;
    }

    var regex = new RegExp(searchFilter, 'i');
    if (get(user, "name").match(regex) || get(user, "email").match(regex)) {
      return true;
    }

    return false;
  }).property('model.length', 'searchFilter'),

  sortedContent: Ember.computed.sort('filteredContent', 'sortProperties').property('filteredContent'),


  actions: {
    clearFilter: function() {
      this.set('searchFilter', '');
    },
  }

});
