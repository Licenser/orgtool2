import Ember from 'ember';

export function decrement(params/*, hash*/) {
  if (params.length != 1) {
    return "";
  }

  var val = params[0];
  return val.toLocaleString(undefined, {minimumFractionDigits: 2});
}

export default Ember.Helper.helper(decrement);
