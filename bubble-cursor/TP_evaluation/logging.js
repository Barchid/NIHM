

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

function initResultats() {
	Resultats[0] += '\t' + 'Erreurs' // nombre d'erreurs
	Resultats[0] += '\t' + 'Temps' // temps pris
}

function initCinematiques() {
	
}

function logEvent(values) {

	/* TODO Ajouter un événement aux logs cinématiques. Tous les champs doivent être remplis. */

}

function logTrial(trial) {
	const diff = new Date().getTime() - startDate.getTime();
	const logInfo = [
		currentParticipant,
		trial.Technique,
		trial.Distance,
		trial.Taille,
		trial.Densite,
		trial.Direction,
		trial.Bloc,
		trial.Trial,
		nbErrors,
		diff
	]
	Resultats.push(logInfo.join('\t'))
}
