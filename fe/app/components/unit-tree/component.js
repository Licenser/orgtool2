import Ember from 'ember';
import UnitColor from 'orgtool/mixins/unit-color';

var debug = Ember.Logger.debug;

export default Ember.Component.extend(UnitColor, {
  session: Ember.inject.service(),
  myEvents: Ember.inject.service('events'),
  level: null,

  showUnits: false,
  showLeader: true,
  showMembers: true,
  showApplicants: true,

  //   seven: Ember.computed.filterBy('unit.playerUnits.@each', 'reward', 7),

  setup: Ember.on('init', function() {
    var level = this.get('level');
    var unit = this.get('unit');
    if (unit) {
      unit.reload();
    }
    var showAbove = this.get('session.current_user.unfold-level');
    this.set('showUnits', level >= showAbove);
    //     this.set('showLeader', level > 0);
    //     this.set('showMembers', level > 0);
  }),

  unitStyle: Ember.computed('unit', 'unit.color', function() {
    return this.getColor(this.get("unit"));
  }),

  setupDrops: Ember.on('didInsertElement', function() {
    var unit = this.get('unit');

    if (unit) {
      this.$(".drop-target").droppable({
        tolerance: 'pointer',
        hoverClass: 'hovered',
      });
    }
  }),

  onNodeDropped: function(event, ui) {
    var id = parseInt(ui.draggable.data('playerid'));
    var unitid = $(event.target).data('unitid');
    Ember.Logger.debug("droped here", id, unitid);
  },

  actions: {
    toggleUnits: function() {
      this.set('showUnits', ! this.get('showUnits'));
      Ember.Logger.debug("showUnits", this.get('showUnits'));
    },
    toggleLeader: function() {
      this.set('showLeader', ! this.get('showLeader'));
    },
    toggleMembers: function() {
      this.set('showMembers', ! this.get('showMembers'));
    },
    toggleApplicants: function() {
      this.set('showApplicants', ! this.get('showApplicants'));
    },


    addUnit: function() {
        Ember.Logger.log("ADD UNNIT ");
      this.get('myEvents').trigger('addUnit', { 'id': this.get('unit.id'), 'type': 'unit', 'unitType': 6 } );
    },
    addGame: function() {
      this.get('myEvents').trigger('addGame', { 'id': this.get('unit.id'), 'type': 'game', 'unitType': 2 } );
    },
    editUnit: function() {
      this.get('myEvents').trigger('editUnit', { 'id': this.get('unit.id'), 'type': "unit", 'unit': this.get('unit') } );
    },
    deleteUnit: function() {
      this.get('myEvents').trigger('deleteUnit', { 'id': this.get('unit.id'), 'type': "unit", 'unit': this.get('unit') } );
    }
  }
});
