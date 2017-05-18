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

//     console.debug("SEND ", serialized);
    return serialized;
  },

  serializeBelongsTo(snapshot, json, relationship){
    let serialized = this._super(...arguments);
    var key = relationship.key;
    var belongsTo = snapshot.belongsTo(key);
    if (belongsTo) {
//       console.debug("--- serializeBelongsTo ", key, "-", belongsTo);
      var js = {"type": key, "id": belongsTo.id, "attributes": belongsTo.record.toJSON() };
      if (json.included) {
        json.included.push(js);
      } else {
        json["included"] = [ js ];
      }
    } else {
      console.debug("--- EMPTY: serializeBelongsTo ", key);
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
      console.debug("--- EMPTY: serializeHasMany ", key);
    }
    return serialized;
  },
});
