import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),

  template: DS.belongsTo('template', { inverse: 'items' }),
  unit: DS.belongsTo('unit', { inverse: 'items' }),
  player: DS.belongsTo('player'),
  itemProps: DS.hasMany('itemProp', { async: true }),

  hidden: DS.attr(),
  available: DS.attr(),
});
