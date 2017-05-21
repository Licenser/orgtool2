import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),
  color: DS.attr(),

  unitType: DS.belongsTo('unitType', { inverse: 'units' }),
  unit: DS.belongsTo('unit', { inverse: 'units' }),

  ships: DS.hasMany('ship', { inverse: 'unit' }),
  units: DS.hasMany('unit', { inverse: 'unit' }),
  players: DS.hasMany('player', { inverse: 'playerships' }),
  leaders: DS.hasMany('player', { inverse: 'leaderships' }),
  applicants: DS.hasMany('player', { inverse: 'applications' }),
});
