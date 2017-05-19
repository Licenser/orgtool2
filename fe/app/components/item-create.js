import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),
  item: null,

  setup: Ember.on('init', function() {
    var self = this;

    get(this, 'store').findAll('category').then(function(categories) {
      debug("categories: ", get(categories, "length"));
      self.set('categories', categories);
    });

    get(this, 'store').findAll('template').then(function(templates) {
      debug("templates: ", get(templates, "length"));
      self.set('templates', templates);
    });

//     if (get(this, "item.id")) {
//       get(this, 'store').findRecord('item', get(this, "item.id")).then(function(nitem) {
//         debug("imte: ", get(nitem, "name"));
//         self.set('item', categories);
//       });
//     }
  }),

  actions: {
    changeOwner: function(owner) {
      var item = get(this, "item");
      set(item, "player", owner);
//       debug("change owner", get(owner, "name"));
      /*
      item.save().then(function(done) {
        debug("saved....", get(done, "id"));
      }).catch(function(err) {
        debug("item-create save failed, err", err);
//         item.rollbackAttributes();
      });
      */
    },

    unassignFromUnit: function(unitid) {
      var item = get(this, "item");
      set(item, "unit", null);
      /*
      debug("save...", get(item, "unit.name"));
      item.save().then(function(done) {
        debug("......saved", get(done, "id"));
      }).catch(function(err) {
        debug("item-create remove unit failed, err", err);
      });
      */
    },

    assignToUnit: function(unitid) {
      var item = get(this, "item");
      var unit = get(this, "store").peekRecord("unit", unitid);
      set(item, "unit", unit);
      /*
      item.save().then(function(done) {
        debug("saved....", get(done, "id"));
      }).catch(function(err) {
        debug("item-create save unit failed, err", err);
      });
      */
    },

    setTemplate: function(template) {
      set(this, "item.template", template);
      set(this, "item.name", get(template, "name"));
      set(this, "item.img", get(template, "img"));
    },

    saveItem: function() {
      var item = get(this, "item");
      if (item) {
        var self = this;
        item.save().then(function(nitem) {
          self.set('item', null);
          self.set('showDialog', false);
          get(self, "session").log("item", "item " + nitem.get("name") + " saved");
        }).catch(function(err) {
          get(self, "session").log("error", "could not save item " + item.get("name"));
          Ember.Logger.log("error saving", err);
          self.set('showDialog', true);
        });
      }
    },
    close: function() {
      var item = get(this, 'item');
      if (!Ember.isEmpty(item)) {

        if (!Ember.isEmpty(item.get("id"))) {
          item.reload();
        } else if (item.get("isNew")) {
          var self = this;
          item.destroyRecord().then(function() {
            get(self, "session").log("item", "item " + item.get("name") + " deleted");
          }).catch(function(err) {
            get(self, "session").log("error", "could not save item " + item.get("name"));
            Ember.Logger.debug("error deleteing item", err);
          });
        }
      }
      this.set('item', null);
      this.set('showDialog', false);
    },
  }

});
