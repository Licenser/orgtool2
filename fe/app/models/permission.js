import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  user: DS.belongsTo('user'),

  active: DS.attr(),

  user_read: DS.attr(),
  user_create: DS.attr(),
  user_edit: DS.attr(),
  user_delete: DS.attr(),

  player_read: DS.attr(),
  player_create: DS.attr(),
  player_edit: DS.attr(),
  player_delete: DS.attr(),

  unit_read: DS.attr(),
  unit_create: DS.attr(),
  unit_edit: DS.attr(),
  unit_delete: DS.attr(),
  unit_apply: DS.attr(),
  unit_accept: DS.attr(),
  unit_assign: DS.attr(),

  ship_model_read: DS.attr(),
  ship_model_create: DS.attr(),
  ship_model_edit: DS.attr(),
  ship_model_delete: DS.attr(),

  ship_read: DS.attr(),
  ship_create: DS.attr(),
  ship_edit: DS.attr(),
  ship_delete: DS.attr(),

  reward_read: DS.attr(),
  reward_create: DS.attr(),
  reward_edit: DS.attr(),
  reward_delete: DS.attr(),

  //   inserted_at: DS.attr(),
  //   created_at: DS.attr(),


  settings: Ember.computed('user_read', 'ship_read', 'reward_read', function() {
    return this.get('user_read') || this.get('ship_read') || this.get('reward_read');
  }),

  ship_list_filter: Ember.computed('ship_model_read', 'ship_read', function() {
    return this.get('user_read') || this.get('ship_read') || this.get('reward_read');
  }),

  ship_tb: Ember.computed('ship_edit', 'ship_delete', function() {
    return this.get('ship_edit') || this.get('ship_delete');
  }),
});
