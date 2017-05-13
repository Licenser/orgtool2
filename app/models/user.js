import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  email: DS.attr(),
//   inserted_at: DS.attr(),
//   created_at: DS.attr(),
  player: DS.belongsTo('player'),
  permission: DS.belongsTo('permission'),
});
