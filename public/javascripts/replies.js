document.observe("dom:loaded", function(event) {
  new Autocompleter.Local("name", "autocomplete_name", reply_names, {
    frequency: 0.1
  });
  $('name').focus();
});
