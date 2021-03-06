import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),
  unit_id: DS.attr(),
  ship_model_id: DS.attr(),

  ship_model: DS.belongsTo('ship-model', { inverse: 'ships', async: false }),
  unit: DS.belongsTo('unit', { inverse: 'ships', async: false }),
  player: DS.belongsTo('player', { async: false }),

  hidden: DS.attr(),
  available: DS.attr(),
});
