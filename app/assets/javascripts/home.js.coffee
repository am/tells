
console.log "Storytellers"

onTells = (data) ->
  console.log data

tells = jQuery.getJSON "/tells.json", onTells
