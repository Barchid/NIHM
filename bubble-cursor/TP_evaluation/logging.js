

/* Une ligne par trial + noms de colonnes */
var Resultats = [];

/* Une ligne par mouse event + noms de colonnes */
var Cinematiques = [];


/*
	Initialisation des logs, notamment les noms de colonne (y compris les mesures).
*/
function initLogs() {

	Resultats.push(ParamNamesInOrder.join('\t'));
	Cinematiques.push(ParamNamesInOrder.join('\t'));

	/* TODO colonnes supplémentaires (mesures, etc.) */

}

function logEvent(values) {

	/* TODO Ajouter un événement aux logs cinématiques. Tous les champs doivent être remplis. */

}

function logTrial(values) {

	/* TODO Ajouter un trial aux logs principaux. Tous les champs doivent être remplis. */

}
