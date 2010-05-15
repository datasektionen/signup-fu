var current_step = 1;
var tabs = null;

document.observe("dom:loaded", function(event) {
  tabs = new Control.Tabs('event_tabs');
});


next_step = function() {
  tabs.next();
}
