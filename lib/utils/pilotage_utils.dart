bool chekcAccesPilotage(Map accesPilotage) {
  if (accesPilotage["est_bloque"]) {
    return false;
  }
  if (accesPilotage["est_admin"]) {
    return true;
  }
  if (accesPilotage["est_spectateur"] || accesPilotage["est_editeur"] || accesPilotage["est_validateur"] ) {
    return true;
  }
  return false;
}