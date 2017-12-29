import DS from 'ember-data';
import Ember from 'ember';
import config from '../config/environment';

export default DS.JSONAPISerializer.extend({
  payloadKeyFromModelName: function(modelName) {
      return Ember.String.singularize(modelName);
  },

  serialize(snapshot) {
    let serialized = this._super(...arguments);

    if (serialized.data.included) {
      serialized.included = serialized.data.included;
      delete serialized.data.included;
    }
    return serialized;
  },

  serializeBelongsTo(snapshot, json, relationship){
    let serialized = this._super(...arguments);
    var key = relationship.key;
    var belongsTo = snapshot.belongsTo(key);

    if (key == "unit") {
      json.attributes['unit_id'] = (json.relationships.unit && json.relationships.unit.data) ? json.relationships.unit.data.id : null;
      delete json.attributes['unit-id'];
    } else if (key == "ship_model") {
//       json.attributes['ship_model_id'] = json.attributes['ship-model-id'];
//       delete json.attributes['ship-model-id'];
    }

    if (belongsTo) {
      var js = {"type": key, "id": belongsTo.id, "attributes": belongsTo.record.toJSON() };
      if (json.included) {
        json.included.push(js);
      } else {
        json["included"] = [ js ];
      }
    } else {
    }
    return serialized;
  },

  serializeHasMany(snapshot, json, relationship){
    let serialized = this._super(...arguments);
    var key = relationship.key;
    var hasMany = snapshot.hasMany(key);
    if (hasMany) {
      var rels = [];
        hasMany.forEach(function(snap) {
          var js = {"type": key, "id": snap.id, "attributes": snap.record.toJSON() };
          rels.push(js);
      });
      if (json.included) {
        json.included.concat(rels);
      } else {
        json["included"] = rels;
      }
    } else {
    }
    return serialized;
  },
});
