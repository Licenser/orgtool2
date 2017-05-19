import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export default Ember.Component.extend({
  classNames: ['item-details'],
  store: Ember.inject.service('session'),
  session: Ember.inject.service('session'),
  item: null,
  details: false,
  tb: true,


  typeName: Ember.computed('item', function() {
    var type = get(this, "item.constructor.modelName")
    if (!type) {
      type = "template";
    }
    return "components/item-" + type + "-details";
  }),


  willRender() {
    this._super(...arguments);
    var type = get(this, "item.constructor.modelName")
    
    if (get(this, "item.id") && type != "category") {
      
      if ((type == "template" && Ember.isEmpty(get(this, "item.templateProps"))) ||
          (type == "item" && Ember.isEmpty(get(this, "item.template.category.img")))) {
        var temp = get(this, "item").reload();
        if (type == "item") {
          temp.then(function(nitem) {
            get(nitem, "template").reload();
          });
        }
      }
    }
  },

/*
  props: Ember.computed("item.templateProps", function() {
    var ret = [];
    var props = get(this, "item.templateProps");
    if (!Ember.isEmpty(props)) {
      console.debug(">>> get those props", props);

      props.forEach(function(p) {
        if (p.get("name") == "crew") {
          ret.push("c: " + p.get("value"));
        } else if (p.get("name") == "length") {
          ret.push("l: " + p.get("value"));
        } else if (p.get("name") == "mass") {
          ret.push("m: " + p.get("value"));
        }
      });
    }
    return ret.join(" | ");
  }),
*/
/*
  didReceiveAttrs() {
    this._super(...arguments);
//     console.debug(">>>>>>>>>> receivedAttr item details");
    var type = get(this, "item.constructor.modelName")
    if (type == "item") {
      console.debug(">>>>>>>>>> receivedAttr", get(this, "item.id"));
      get(this, store).findRecord('item', get(this, "item.id")).then(function(it) {
        console.debug(">>>>>>>>>> fetched new iten", get(it, "it.id"));
      });
    }
  },
*/


/*
  didInsertElement() {
    this._super(...arguments);
//     this.$().attr('contenteditable', true);

      console.debug(">>>>>>>>>>  didInsertElement", get(this, "item.id"), " | ", get(this, "item.constructor.modelName") );
    var type = get(this, "item.constructor.modelName")
    if (type == "item") {
    }
  },
*/

/*
  init() {
    this._super(...arguments);
    console.debug(">>>>>>>>>> INIT", get(this, "item.id"));
//     this.errors = [];
  },

  didUpdateAttrs() {
    this._super(...arguments);
    console.debug(">>>>>>>>>> updateAttr", get(this, "item.id"));
//     this.set('errors', []);
  },

  didReceiveAttrs() {
    this._super(...arguments);
//     console.debug(">>>>>>>>>> receivedAttr item details");
    console.debug(">>>>>>>>>> receivedAttr", get(this, "item.id"));
  },

  didInsertElement() {
    this._super(...arguments);
//     this.$().attr('contenteditable', true);
    console.debug(">>>>>>>>>>  didInsertElement", get(this, "item.id"));
  },

  wtf: function() {
    console.debug(">>>>>>>>>>  COMPUTE", get(this, "item.id"));
  }.observes('item'),
*/
  actions: {
    deleteItem: function(item) {
      this.get('onConfirm')(item);
    },

    editItem: function(item) {
      this.get('onEdit')(item);
    },
  }
});
