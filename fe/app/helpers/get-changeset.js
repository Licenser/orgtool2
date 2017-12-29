import Ember from 'ember';

var get = Ember.get;
// var get = Ember.get;

export function getChangeset(params/*, hash*/) {
  if (params.length != 1) {
    return "";
  }

  var val = params[0];
  var ret = {};
  if (get(val, "changedAttributes")) {
    ret = val.changedAttributes();
    console.debug(" GET CHANGE SET", ret);
  }
  return ret;
}

export default Ember.Helper.helper(getChangeset);
