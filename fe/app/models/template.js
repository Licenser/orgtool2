import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),

  category: DS.belongsTo('category', { async: false }),

  templateProps: DS.hasMany('templateProp', { async: false }),
  items: DS.hasMany('item', { async: false }),
});
