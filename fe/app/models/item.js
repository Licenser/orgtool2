import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),

  template: DS.belongsTo('template', { inverse: 'items', async: false }),
  unit: DS.belongsTo('unit', { inverse: 'items', async: false }),
  player: DS.belongsTo('player', { async: false }),

  itemProps: DS.hasMany('itemProp', { async: false }),

  hidden: DS.attr(),
  available: DS.attr(),
});
