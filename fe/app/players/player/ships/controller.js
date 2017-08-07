import Ember from 'ember';
// import Moment from 'moment';

var get = Ember.get;
var set = Ember.set;

export default Ember.Controller.extend({
  store: Ember.inject.service(),
  myEvents: Ember.inject.service('events'),
  session: Ember.inject.service('session'),
  showDialog: false,

  showShipDialog: false,

  sortProperties: ['name:asc'],
  sortedShipModels: Ember.computed.sort('shipModels', 'sortProperties'),
  columns: [25, 25, 25, 25],
  itemHeight: 120,

  actions: {
    submit: function() {
      var self = this;

      self.set('showDialog', false);
    },

    saveMember: function(player) {
      this.get('myEvents').trigger('saveMember', player);

      player.save().then(function(mem) {
        Ember.Logger.debug("save ok", mem);
      }).catch(function(err) {
        Ember.Logger.debug("save not ok", err);
      });
    },

    deleteMember: function(player) {
      Ember.Logger.debug("delete user now", player);
      set(this, "msg", { "type": "delete", "item": player, "title": "Delete Member!", "content": "Do you really want to delete player " + player.get("id") + " | " + player.get("name") + "?" });
      set(this, "showConfirmDialog", true);

    },

    onConfirmed: function(msg) {
      Ember.Logger.debug("on confirm del mem", msg, " - ", get(msg, "item"));
      if (!msg || !msg.item) {
        return;
      }
      Ember.Logger.debug("delete user");
      var self = this;
      msg.item.destroyRecord().then(function(done) {
        set(self, "showConfirmDialog", false);
        self.transitionToRoute('players');
      }).catch(function(err) {
        Ember.Logger.debug("delete  user", err);
      });
    },

    addShip: function(player) {
      var ship = this.store.createRecord('ship');
      ship.set('player', player);
      this.set('currShip', ship);
      this.set('showDialog', true);
    },
    editShip: function(ship) {
      if (ship) {
        var self = this;
        this.set('currShip', ship);
        this.set('showDialog', true);
      }
    },
    setModel: function(shipModel) {
      var ship = get(this, 'currShip');
      ship.set('model', shipModel);
    },
    close: function() {
//       Ember.Logger.debug("the other close...");
      this.set('showDialog', false);
      this.transitionToRoute('players');
    },
    /*
    close: function() {
      var ship = get(this, 'currShip');
      if (ship) {
        ship.deleteRecord();
        this.set('currShip', null);
      }
      this.set('showDialog', false);
    },
    */
    saveShip: function() {
      var ship = get(this, 'currShip');
      if (ship) {
        var self = this;
        var memid = get(ship, 'player.id');
        self.get('myEvents').trigger('log', 'adding ship to player: ' + memid);
        self.get('myEvents').trigger('setLoading', true);
        self.set('showDialog', false);
        ship.save().then(function(nship) {
          self.get('myEvents').trigger('success', 'ship added to player: ' + memid);
          self.set('currShip', null);
          self.set('showDialog', false);
        }).catch(function(err) {
          self.get('myEvents').trigger('failure', 'counld not add ship to player: ' + memid);
          Ember.Logger.debug("error saving", err);
          self.set('showDialog', true);
        });
      }
    },
    meldShip: function(ship) {
      if (ship) {
        var self = this;
        var memid = get(ship, 'player.id');
        self.get('myEvents').trigger('log', 'melting ship of player: ' + memid);
        self.get('myEvents').trigger('setLoading', true);
        ship.destroyRecord().then(function(nship) {
          self.get('myEvents').trigger('success', 'ship melted of player: ' + memid);
        }).catch(function(err) {
          self.get('myEvents').trigger('failure', 'counld not melt ship of player: ' + memid);
          Ember.Logger.debug("error melting", err);
        });
      }
    },
  }
});
