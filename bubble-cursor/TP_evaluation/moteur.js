/* 	
	"Dictionnaire" qui va contenir tout le "scénario", une ligne par trial.
	La structure est {nom_de_colonne_1: [une valeur par trial], nom_de_colonne_2: [une valeur par trial], etc.}
*/
var Trials = [];

/* Liste des noms de colonnes dans le bon ordre, au cas où le "dictionnaire" ne respecte pas l'ordre. */
var ParamNamesInOrder = [];

/* Fonction utilitaire permettant d'obtenir toutes les valeurs uniques dans une liste. */
function onlyUnique(value, index, self) {
	return self.indexOf(value) === index;
}

/*
	Lecture d'un fichier de scénario.
	Le fichier de scénario doit être au format .tsv (tab-separated values) et commencer par une ligne
	décrivant les noms de colonnes.
	Le fichier est chargé en cliquant sur un bouton en haut de la page.
*/
function lireScenario(event) {

	let input = event.target;
	let reader = new FileReader();

	reader.onload = function () {
		let text = reader.result.split('\n');

		// First line: Parameter names

		ParamNamesInOrder = text[0].split('\t');
		for (let i = 0; i < ParamNamesInOrder.length; i++) {
			Trials[ParamNamesInOrder[i]] = [];
		}


		// Next lines: Trials

		for (let i = 1; i < text.length; i++) {
			let paramValues = text[i].split('\t');
			for (let j = 0; j < paramValues.length; j++) {
				Trials[ParamNamesInOrder[j]][i] = paramValues[j];
			}
		}

		// Ajouter les noms des participants dans le <select> du canvas.html
		let uniqueParticipants = Trials['Participant'].filter(onlyUnique);

		let select = document.getElementById('Plist');
		for (let i = 0; i < uniqueParticipants.length; i++) {
			var opt = document.createElement('option');
			opt.value = uniqueParticipants[i];
			opt.innerHTML = uniqueParticipants[i];
			select.appendChild(opt);
		}

		// Voir logging.js
		initLogs();

		// Charger le premier gitan
		chargerParticipant();
	};

	reader.readAsText(input.files[0]);
};

// Participant courant
let currentParticipant;

// Timestamp de début du trial
let startTS;

// tableau des trials pour le participant courant
let participantTrials;

// Indice du trial courant pour le participant courant
let trialIndex;

// Longueur (en pixel) d'un millimètre pour l'écran utilisé
const pxMM = 5;

function chargerParticipant() {
	currentParticipant = getSelectedParticipant()
	participantTrials = loadParticipantTrials()
	trialIndex = 0;
	new Target(100, 100, 50, true);
	new Target(100, 200, 50, true);
	new Target(300, 200, 50, true);
	new Target(300, 400, 50, false);
	new Target(500, 400, 50, true);

}

function trialSuivant() {

	alert("TODO trialSuivant()");
	/* TODO fonction à appeler pour passer au trial suivant.
		- Logguer les résultats
		- Vérifier qu'il ne s'agit pas du dernier trial pour ce participant
		- Nettoyer le canvas
		- Générer un nouveau canvas à partir des paramètres du trial
	*/

	if(trialIndex >= participantTrials.length-1) {
		alert("FIN pour le participant " + currentParticipant);
	}

}



// FONCTIONS UTILITAIRES

function loadTrial() {
	const trial = participantTrials[trialIndex];
	const T = trial.Taille * pxMM; // longueur d'un cube en px
	const D = (trial.Densite/100) * T; // distance D de la densité en px
	const zone = 500 + T; // taille de la zone où sont dessinés les cibles
	const A = trial.Distance * pxMM; 
}

/**
 * Fonction qui dessine le canvas à utiliser pour le trial courant
 * @param {*} trial 
 */
function drawScene(trial) {
	
}

/**
 * Fonction qui dessine, pour le y donné, la ligne de carrés qui s'y trouvent
 * @param {*} trial 
 * @param {number} y la coord y où se trouve la ligne à dessiner
 * @param {number} x0 la coord x initiale où commencera la ligne
 */
function drawRows(trial, y, x0) {
	const T = trial.Taille * pxMM; // longueur d'un cube en px
	const D = (trial.Densite/100) * T; // distance D de la densité en px
	const zone = 500 + T; // taille de la zone où sont dessinés les cibles
	let x = x0;

	// TANT QUE [je peux dessiner un carré]
	let canDraw = true;
	while(canDraw) {
		// ALORS [je dessine une target]
		new Target(x, y, T, true);

		canDraw = x + T + D <= zone;
		x+= D + T;
	}
}

/**
 * Fonction qui renvoie le participant sélectionné dans le <select> du canvas.html
 */
function getSelectedParticipant() {
	let select = document.getElementById('Plist');
	return select.options[select.selectedIndex].value;
}

// récupère tous les trials du participant courant et 
function loadParticipantTrials() {
	const result = []
	for (let i = 0; i < Trials["Participant"].length; i++) {
		if(Trials["Participant"][i] == currentParticipant) {
			result.push({
				"Technique": Trials["Technique"][i],
				"Distance" : Trials["Distance"][i],
				"Taille": Trials["Taille"][i],
				"Densite": Trials["Densite"][i],
				"Direction": Trials["Direction"][i],
				"Bloc": Trials["Bloc"][i],
				"Trial": Trials["Trial"][i],
			})
		}
	}

	return result;
}