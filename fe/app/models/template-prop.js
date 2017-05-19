import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  value: DS.attr(),
  template: DS.belongsTo('template', { async: true })
});
