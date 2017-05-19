import Ember from 'ember';

var get = Ember.get;
var set = Ember.set;

export function getItemProp(params/*, hash*/) {
  var result = "-";
  if (params.length != 2) {
    return result;
  }

  var props = params[0];
  var propName = params[1];

  if (Ember.isEmpty(props) || Ember.isEmpty(propName)) {
    return result;
  }

  var res = props.filterBy("name", propName);
  if (res) {
    result = res[0].get("value");
  }
  return result;
}

export default Ember.Helper.helper(getItemProp);
