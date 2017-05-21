import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),

  'ship-model': DS.belongsTo('ship-model', { inverse: 'ships', async: false }),
  unit: DS.belongsTo('unit', { inverse: 'ships', async: false }),
  player: DS.belongsTo('player', { async: false }),

  hidden: DS.attr(),
  available: DS.attr(),
});
