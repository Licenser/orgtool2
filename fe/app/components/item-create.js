import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['item-create'],
  store: Ember.inject.service(),
  session: Ember.inject.service('session'),

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

    if (get(this, "item.id")) {
      get(this, 'store').findRecord('item', get(this, "item.id")).then(function(nitem) {
        debug("imte: ", get(nitem, "name"));
//         self.set('item', categories);
      });
    }
  }),

  actions: {
    changeOwner: function(owner) {
      var item = get(this, "item");
      set(item, "player", owner);
//       debug("change owner", get(owner, "name"));
      item.save().then(function(done) {
        debug("saved....", get(done, "id"));
      }).catch(function(err) {
        debug("item-create save failed, err", err);
//         item.rollbackAttributes();
      });
    },

    unassignFromUnit: function(unitid) {
      var item = get(this, "item");
      get(this, "store").findRecord("unit", unitid).then(function(unit) {
        unit.get("items").removeObject(item);
        unit.save().then(function(done) {
          debug("saved....", get(done, "id"));
        }).catch(function(err) {
          debug("item-create save unit failed, err", err);
        });
      });
//       set(item, "unit", null);
      /*
      item.save().then(function(done) {
        debug("saved....", get(done, "id"));
      }).catch(function(err) {
        debug("item-create remove unit failed, err", err);
      });
      */
    },

    assignToUnit: function(unitid) {
      var item = get(this, "item");
      var unit = get(this, "store").peekRecord("unit", unitid);
//       var typename = item.get('constructor.modelName');
//       Ember.Logger.debug("element type", typename);

//       debug("assitn item to unit", get(item, "name"), typename, "  -->", unitid);

      set(item, "unit", unit);
      item.save().then(function(done) {
//         debug("saved....", get(done, "id"));
      }).catch(function(err) {
        debug("item-create save unit failed, err", err);
      });

/*
      var store = get(this, "store");
      store.findRecord("item", get(it, "id")).then(function(item) {
        store.findRecord("unit", unitid).then(function(unit) {
          debug("assitn item to unit", get(item, "name"), "->", unitid, "-------", unit.get("items"));

          unit.get("items").pushObject(item);
          unit.save().then(function(done) {
            debug("saved....", get(done, "id"));
          }).catch(function(err) {
            debug("item-create save unit failed, err", err);
          });
        });
      });

      */
    },

    setTemplate: function(template) {
      set(this, "item.template", template);
      set(this, "item.name", get(template, "name"));
      set(this, "item.img", get(template, "img"));
    },

    setParent: function(par) {
    },

    saveItem: function() {
      var item = get(this, "item");
      if (item) {
        //         Ember.Logger.debug("save item", item.get("name"), item.get("parent").get("name"), "-", item.get("type").get("name"), "-", item.get("player").get("id"));
        var self = this;
        var mem = get(item, 'player');
        var memid = get(mem, 'id');
        //         self.set('showDialog', false);
        item.save().then(function(nitem) {
          //           self.get('eventManager').trigger('success', 'ship added to player: ' + memid);
          //           Ember.Logger.debug(">>>>", nitem.get("id"), "-", mem.get("items")); //.get("length"));
//           mem.get("items").pushObject(nitem);
          self.set('item', null);
          self.set('showDialog', false);

          Ember.Logger.log("save ok ", nitem , " |" , get(nitem, "player"));
          get(self, "session").log("item", "item " + nitem.get("name") + " saved");
          //           Ember.Logger.debug(">>>> SAVED!", nitem.get("id"), "-", mem.get("items")); //.get("length"));
        }).catch(function(err) {
          //           self.get('eventManager').trigger('failure', 'counld not add ship to player: ' + memid);
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

//         if (!Ember.isEmpty(item.get("player")) && !Ember.isEmpty(item.get("player").get("items"))) {
          //         Ember.Logger.debug(">>> RELOAD  MEMBER");
          //           item.get("player").get("items").reload();
//         }
      }
      this.set('showDialog', false);
      this.set('item', null);
    },
  }

});
