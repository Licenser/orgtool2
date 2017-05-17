// import DS from 'ember-data';
// export default DS.JSONAPISerializer.extend(DS.EmbeddedRecordsMixin,{
//   attrs: {
//     screenshots: { embedded: 'always' }
//   }
// });

import DS from 'ember-data';
import Ember from 'ember';
import config from '../config/environment';

// export default DS.JSONAPISerializer.extend(DS.EmbeddedRecordsMixin, {
export default DS.JSONAPISerializer.extend({

  modelNameFromPayloadKey: function(key) {
  //     Ember.Logger.log("---> model", key);
    return Ember.String.singularize(key); //this.normalizeModelName(key));
  },

  payloadKeyFromModelName: function(modelName) {
      return Ember.String.singularize(modelName);
  },

/*
  serialize(snapshot) {
//     console.debug("serialize, snap", snapshot)
//     snapshot['include'] = ['permission'];
    let serialized = this._super(...arguments);

    if (serialized.data.included) {
      serialized.included = serialized.data.included;
      delete serialized.data.included;
    }

    console.debug("serialize", serialized)
    return serialized;
  },

  serializeBelongsTo(snapshot, json, relationship) {
    let serialized = this._super(...arguments);

    var key = relationship.key;
//     if (key == "permission") {
      var belongsTo = snapshot.belongsTo(key);
//       console.debug("serializeBelongsTo snap", snapshot);
//       console.debug("serializeBelongsTo bel ", belongsTo);

//       var js = {"type": key, "id": belongsTo.id, "attributes": belongsTo.record.toJSON() };
      var js = this.serialize(belongsTo).data;
      js["id"] = belongsTo.id;

//       console.debug("--- serializeBelongsTo ", key, "=", belongsTo.record.toJSON());
//       console.debug("--- serializeBelongsTo ", key, "=", js);

      if (json.included) {
        json.included.push(js);
      } else {
        json["included"] = [ js ];
      }
//       console.debug("--- serializeBelongsTo ", key, "=", json);
//     }
  },
*/
});
