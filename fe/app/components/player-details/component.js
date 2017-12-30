import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;
var debug = Ember.Logger.log;

export default Ember.Component.extend({
  classNames: ['player-details'],
  classNameBindings: ['compClasses'],
  store: Ember.inject.service(),
  playerManager: Ember.inject.service('player-manager'),
  session: Ember.inject.service('session'),

  player: null,

  draggable: false,
  droppable: true,
  selectable: true,
  unit: null,
  type: null,
  attributeBindings: ["playerid:data-playerid"],
  playerid: Ember.computed.alias('player.id'),
  lastElement: null,
  lastColor: null,
  canDrag: Ember.computed.and('draggable', 'session.current_user.permission.unit_assign'),
  canUnassign: Ember.computed.and('unit', 'session.current_user.permission.unit_assign'),


  compClasses: function() {
    if (this.get('canDrag')) {
      return "player-details-draggable";
    } else if (this.get('details')) {
      return "player-details-selectable";
    }
    return "";
  }.property('details', "canDrag"),

  setup: Ember.on('didInsertElement', function() {
    this.set("reload", true);
    if (!this.get('canDrag')) {
      return;
    }
    this.createDraggable();
  }),

  didRender() {
    this._super(...arguments);
    if (this.get("reload") && this.get("player")) {
      this.set("reload", false);
      this.get("store").findRecord('player', this.get("player.id"));
    }
  },

  mergedUnits: function() {
//     Ember.Logger.log(">>> player cachanged" );
    var res = Ember.A();
    res.pushObjects(get(this, 'player.leaderships').toArray());
    res.pushObjects(get(this, 'player.playerships').toArray());
    res.pushObjects(get(this, 'player.applications').toArray());
    return res;
  }.property('player.leaderships', 'player.playerships', 'player.applications'),
//   }.property('player'),


  reinit: function() {
//     Ember.Logger.log(">>> reinit" );
    if (!this.get('canDrag')) {
      return;
    }
    if (this.$().data('ui-draggable') === undefined) {
      this.createDraggable();
    }
  }.observes('session.current_user.permission.unit_assign'),

  createDraggable: function() {

    this.$().draggable({
      tolerance: 'pointer',
      helper: 'clone',
      cursorAt: { left: -5, top: -5 },
      //       zIndex: 1,
      stack: ".draggable",
      revert: true,
      scroll: false,
      appendTo: "body",
      cursor: "move",
      containment: "#mycontent",
      drag: Ember.$.proxy(this.onDrag, this),
      stop: Ember.$.proxy(this.onDropped, this),
    });

  },

  onDrag: function(e) {
    var el = this.getElementId(e);
    var matches = el.unitid !== undefined;
    if (matches && el.dest == "path") {
      this.setLast(e.toElement);
    } else {
      this.resetLast();
    }
    this.$(e.target).draggable("option","revertDuration",(matches) ? 0 : 100)
  },

  onDropped: function (event, ui) {
    this.resetLast();
    var elm = this.getElementId(event);
    var unitid = elm.unitid;
    if (!unitid) {
      return;
    }

    var id = parseInt(this.$(event.target).data('playerid'));
    debug("assign", id);

    if (elm.dest == "path") {
      elm.dest = "players";
    }

    this.$("body").css("cursor","");
    this.get('playerManager').assign({ 'id': id, 'type': 'player', 'dest': unitid, 'destType': elm.dest } );
  },

  resetLast: function() {
    var last = this.get('lastElement');
    if (last) {
      this.$(last).css({ fill: this.get('lastColor')});

      var classes = this.$(last).attr("class");
      if (classes) {
        classes = classes.split(" ");
        var idx = classes.indexOf("drop-hover");
        if (idx >= 0) {
          classes.splice(idx, 1);
          this.$(last).attr("class", classes.join(" "));
        }
      }
    }
    this.set('lastElement', null);
    this.set('lastColor', null);
  },

  setLast: function(element) {
    var last = this.get('lastElement');
    if (last === element) {
      return;
    }
    this.resetLast();
    this.set('lastElement', element);
    this.set('lastColor', this.$(element).css('fill'));
    this.$(element).removeAttr("style");
    var classes = this.$(element).attr("class");
    //     Ember.Logger.debug(">>> classes", classes);
    if (classes) {
      classes = classes.split(" ");
    } else {
      classes = [];
    }
    classes.push("drop-hover");
    this.$(element).attr("class", classes.join(" "));
  },

  getElementId: function(item) {
    var id;
    var dest = "";

    if (!id) {
      id = this.$(item.originalEvent.target).closest( ".unit-pilots-container" ).data('unitid');
      dest = this.$(item.originalEvent.target).closest( ".unit-pilots-container" ).data('dest');
    }

    if (!id) {
      id = this.$(item.originalEvent.target).closest( ".unit-pilots-path" ).data('unitid');
      dest = "path";
    }

    return {unitid: id, dest: dest};
  },

  loadError(img) {
    Ember.$(img.target).attr("src", Ember.get(this, "session").rootURL + "/member.png");
    //     set(img, "src", get(this, "session").rootURL + "/member.png");
    return true;
  },

  actions: {
    unassignMember: function(player, unit, type) {
      this.get('playerManager').unassign({ 'player': player, 'unit': unit, 'type': type });
    },
  },
});
