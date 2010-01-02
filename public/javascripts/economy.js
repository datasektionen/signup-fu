document.observe("dom:loaded", function(event) {
  $("economy_report_table").observe("click", function(event) {
    if (event.element().nodeName == "INPUT") {
      return;
    }
    var clickedRow = event.findElement('tr');
    if (clickedRow) {
      toggleCheckbox("reply_" + clickedRow.id.sub("reply_row_", ""));
    }
  });
  
  $('economy_report_table').observe("mouseover", function(event) {
    var row = event.findElement('tr');
    if (row) {
      row.addClassName("highlight");
    }
  });
  
  $('economy_report_table').observe("mouseout", function(event) {
    var row = event.findElement('tr');
    if (row) {
      row.removeClassName("highlight");
    }
  });
  
});

function toggleCheckbox(checkbox) {
  checkbox = $(checkbox);
  if (checkbox == null) {
    return;
  }
  checkbox.checked = !checkbox.checked;
}

function toggleFoo(row) {
  toggleCheckbox("reply_" + row.id.sub("reply_row_", ""));
}
