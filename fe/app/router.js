import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('login');

  this.route('overview', function() {
    this.route('unit', { path: '/:unit_id' }, function() {
    });
  });

  this.route('players', function() {
    this.route('player', { path: '/:player_id' }, function() {
      this.route('general');
      this.route('stats');
      this.route('ships');
    });
  });

  this.route('users', function() {
    this.route('user', { path: '/:user_id' }, function() {
    });
  });

  this.route('ships');
  this.route('ship-models');

  this.route('rewards');

  this.route('lfg');
  this.route('log');
});

export default Router;
