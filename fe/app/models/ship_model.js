import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  description: DS.attr(),
  img: DS.attr(),
  'class': DS.attr(),
  mass: DS.attr(),
  crew: DS.attr(),
  length: DS.attr(),
  ship_id: DS.attr(),
  manufacturer: DS.attr(),

  ships: DS.hasMany('ship', { async: false }),
});
