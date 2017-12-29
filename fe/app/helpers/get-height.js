import Ember from 'ember';

export function decrement(params/*, hash*/) {
  if (params.length != 1) {
    return "";
  }

  var val = params[0];
  return Ember.String.htmlSafe("height: " + val + "px");
}

export default Ember.Helper.helper(decrement);
