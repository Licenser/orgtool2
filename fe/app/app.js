import Ember from 'ember';
import Resolver from './resolver';
import loadInitializers from 'ember-load-initializers';
import config from './config/environment';
import DS from 'ember-data';

DS.Model.reopen({

  // this could break at the drop of a hat, so we'll want to test it thoroughly
  changedAttributes() {
    const attributes = this._super(...arguments)
    const relationships = {}

    // check relationships
    this.eachRelationship((name, meta) => {
      if (meta.kind === 'belongsTo') {

        let before = this.get(`_internalModel._relationships.initializedRelationships.${name}.canonicalState.id`)
        let now = this.get(`${name}.id`)

        if (before !== now) {
          relationships[name] = [before, now]
        }
      }
    })

    return Ember.merge(attributes, relationships)
  },

});


const App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver,
  ready: function () {
    $("#loader").remove();
  }
});

loadInitializers(App, config.modulePrefix);

export default App;
