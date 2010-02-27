function toggleTicketExpiry() {
  if ($('ticket_expired').checked) {
    $('ticket_expired_settings').show();
    $('event_mail_templates_ticket_expire_reminder_enabled').value = "1"
  } else {
    $('ticket_expired_settings').hide();
  }
}
