import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-filtered-list'],
  sortProperties: ['numericID'],
  details: false,
  showEdit: false,
  session: Ember.inject.service('session'),
  store: Ember.inject.service('store'),
//   eventManager: Ember.inject.service('events'),
  gameFilter: null,
  typeFilter: "cats",
  columns: [25, 25, 25, 25],
  itemHeight: 400,
  showFilter: true,
  categories: [],
  templates: [],
  items: [],
  showConfirmDialog: false,
  showItemDialog: false,
  showItemTypeDialog: false,

  itemTypeFilter: [],
  adminMode: false,

  setup: Ember.on('didInsertElement', function() {
    var self = this;

//     debug("has player", get(this, "player"));
    if (!Ember.isEmpty(get(this, "player"))) {
      set(this, "items", get(this, "player").get("items"));
    } else {
      get(this, 'store').findAll('item').then(function(items) {
        self.set('items', items);
      });
    }
  }),

  hasParent: function(id, unit) {
    try {
      return unit.get("id") == id || unit.get('parent') && this.hasParent(id, unit.get('parent'));
    } catch(err) {
        Ember.Logger.debug("error", err);
    }
    return false;
  },

  filteredContent: Ember.computed('items', function() {
    var gameFilter = this.get('gameFilter');
    var typeFilter = this.get('typeFilter');
    var res = []

    debug("set filter ", typeFilter);

    if (get(this, "player")) {
      return get(this, "player").get("items");
    } else {
      if (typeFilter == "cats") {
        return get(this, 'store').findAll('category');
      } else if (typeFilter == "tpls") {
        return get(this, 'store').findAll('template');
      } else if (typeFilter == "items") {
        return get(this, 'store').findAll('item');
      }
    }
    return [];

  }).property('typeFilter', "items", "currItem"),

  sortedContent: Ember.computed.sort('filteredContent', 'sortProperties').property('filteredContent'),

  resetAll: function() {
    set(this, "currItem", null);
    set(this, "currCategory", null);
    set(this, "currTemplate", null);

    set(this, "showItemDialog", false);
    set(this, "showCategoryDialog", false);
    set(this, "showTemplateDialog", false);

    set(this, "showConfirmDialog", false);
  },

  actions: {
    setTypeFilter: function(data) {
      set(this, 'typeFilter', data);
    },

    setGameFilter: function(data) {
      set(this, 'gameFilter', data);
    },

    clearFilter: function() {
      this.set('searchFilter', '');
    },

    showConfirm: function(item) {
      Ember.Logger.debug("show confirm", get(item, "name"));
//       var element = get(msg, "item");
      var typename = item.get('constructor.modelName');
      debug("element type", typename);

      set(this, "msg", { "type": "delete", "item": item, "title": "Delete " + typename + "!", "content": "Do you really want to delete the " + typename + " " + item.get("name") + "?" });
      set(this, "showConfirmDialog", true);
    },

    onConfirmed: function(msg) {
//       Ember.Logger.debug("on confirm");
      var element = get(msg, "item");
      var typename = element.get('constructor.modelName');
//       debug("element type", typename);

      var self = this;
      if (element && typename) {
        if (get(msg, "type") == "delete") {
//           Ember.Logger.debug("has mem", get(get(msg, "item"), "player"));

          element.destroyRecord().then(function() {
            get(self, "session").log(typename, element.get("name") + " deleted");

//             Ember.Logger.debug("reset filter", (get(self, "typeFilter") === element));
//             if (get(self, "typeFilter") === element) {
//               set(self, "typeFilter", null);
//             }
          }).catch(function(err) {
            get(self, "session").log("error", "could not delete " + typename + " " + element.get("name"));
            Ember.Logger.debug("error deleting", err);
          }).finally(function() {
            self.resetAll();
          });
        }
      } else {
        self.resetAll();
      }
    },

    showEdit: function(item) {
//       Ember.Logger.debug("show edit", get(item, "name"));
//       var element = get(msg, "item");
      var typename = item.get('constructor.modelName');
//       debug("element type", typename);

      if (typename == "category") {
        this.set('currCategory', item);
        this.set('showCategoryDialog', true);
      } else if (typename == "template") {
        this.set('currTemplate', item);
        this.set('showTemplateDialog', true);
      } else if (typename == "item") {
        this.set('currItem', item);
        this.set('showItemDialog', true);
      }
      return;
//       set(this, "currItem", item);
//       set(this, "showItemDialog", true);
    },


    addCategory: function() {
//       debug("ADD CAT");
      var category = get(this, "store").createRecord('category');
      get(this, "session").log("category", "new category created");
      this.set('currCategory', category);
      this.set('showCategoryDialog', true);
    },

    addTemplate: function() {
//       debug("ADD TEMP");
      var template = get(this, "store").createRecord('template');
      get(this, "session").log("template", "new template created");
      this.set('currTemplate', template);
      this.set('showTemplateDialog', true);
    },

    addItem: function() {
//       debug("ADD ITEM");
      var item = get(this, "store").createRecord('item');
      get(this, "session").log("item", "new item created");
      if (!Ember.isEmpty(get(this, "player"))) {
        item.set('player', get(this, "player"));
        get(this, "session").log("item", "added item to player " + get(this, "player").get("name"));
      }
      this.set('currItem', item);
      this.set('showItemDialog', true);
    },
  }

});
