import Ember from 'ember';


var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Controller.extend({
  classNames: ['item-filtered-list'],
  session: Ember.inject.service(),
  store: Ember.inject.service(),

  sortProperties: ['numericID'],
  details: false,
  showEdit: false,
//   listView: false,

  columns: [16.6, 16.6, 16.6, 16.6, 16.6, 16.6],
  itemHeight: 140,

  showFilter: true,

  showConfirmDialog: false,
  showModelDialog: false,
  showModelTypeDialog: false,

  setup: Ember.on('init', function() {
    var self = this;
    get(this, 'store').findAll('ship-model').then(function(ship_models) {
        self.set('ship_models', ship_models);
    });
  }),

  shipListStyle: Ember.computed('height', function(num) {
    /* Note: You must implement #escapeCSS. */
//     var height = escapeCSS(this.get('height'));
    return Ember.String.htmlSafe("height: " + num + "px");
  }),

  manufacturers: Ember.computed('ship_models', 'listView', function() {
    var loockup = {};
    var res = Ember.A();

    if (!get(this, "ship_models")) {
      return res;
    }
    var self = this;
    get(this, 'ship_models').forEach(function(ship) {
        var mname = get(ship, "manufacturer");
        if (!loockup[mname]) {
          loockup[mname] = {name: mname, idx: get(res, "length")};
          res.pushObject({name: mname, height: 0, ships: Ember.A()});
        }
        res.objectAt(loockup[mname].idx).ships.pushObject(ship);
        res.objectAt(loockup[mname].idx).height = Math.ceil(res.objectAt(loockup[mname].idx).ships.length / self.get("columns").length) * self.get("itemHeight"); 
    });

    $('.item-list').focus();
    return res;
  }),

/*
  models: Ember.computed(function() {
    this.set("loading", true);
    var res;
    res = get(this, "store").findAll("ship-model");
    this.set("loading", false);
    return res;
  }),


  sortedModels: Ember.computed.sort('models', function(a, b) {
    var crew_a = a.get('crew'),
        crew_b = b.get('crew'),
        man_a = a.get('manufacturer'),
        man_b = b.get('manufacturer'),
        name_a = a.get('name'),
        name_b = b.get('name');
    // sort by manufacturer first
    if (man_a > man_b) return 1;
    if (man_a < man_b) return -1;
    // sort by crew second
    // Note: 1 and -1 flipped to get reverse sort order aka
    // largest ship first.
    if (crew_a > crew_b) return -1;
    if (crew_a < crew_b) return 1;
    // last we sort by name
    if (name_a > name_b) return 1;
    if (name_a < name_b) return -1;
    return 0;
  }),
*/
  showConfirm: function(model) {
//     Ember.Logger.debug("show confirm", get(model, "name"));

    set(this, "msg", { "type": "delete", "item": model, "title": "Delete model!", "content": "Do you really want to delete the model " + model.get("name") + "?" });
    set(this, "showConfirmDialog", true);
  },

  resetAll: function() {
    set(this, "currModel", null);
    set(this, "showModelDialog", false);
    set(this, "showConfirmDialog", false);
  },

  actions: {
    setTypeFilter: function(data) {
      set(this, 'typeFilter', data);
    },

    clearFilter: function() {
      this.set('searchFilter', '');
    },

    showConfirm: function(model) {
//       Ember.Logger.debug("show confirm", get(model, "name"));

      set(this, "msg", { "type": "delete", "item": model, "title": "Delete model!", "content": "Do you really want to delete the model " + model.get("name") + "?" });
      set(this, "showConfirmDialog", true);
    },

    onConfirmed: function(msg) {
      var element = get(msg, "item");
      var self = this;
      if (element) {
        if (get(msg, "type") == "delete") {
          element.destroyRecord().then(function() {
            get(self, "session").log('model', element.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not delete model " + element.get("name"));
            Ember.Logger.debug("error deleting", err);
          }).finally(function() {
            self.resetAll();
          });
        }
      } else {
        self.resetAll();
      }
    },

    showEdit: function(model) {
      this.set('currModel', model);
      this.set('showModelDialog', true);
    },

    addModel: function() {
//       debug("ADD Model");
      var model = get(this, "store").createRecord('ship_model');

      this.set('showModelDialog', true);
      this.set('currModel', model);
    },

    setListView: function(listView) {
      if (listView) {
        set(this, "columns", [100]);
        set(this, "itemHeight", 52);
      } else {
        set(this, "columns", [16.6, 16.6, 16.6, 16.6, 16.6, 16.6]);
        set(this, "itemHeight", 140);
      }
      set(this, "listView", listView);
    },

  },
});
