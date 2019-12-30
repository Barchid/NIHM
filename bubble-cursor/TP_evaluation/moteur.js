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

// Date de début du trial courant
let startDate;

// nombre d'erreurs enregistrées pour le trial courant
let nbErrors;

// tableau des trials pour le participant courant
let participantTrials;

// Indice du trial courant pour le participant courant
let trialIndex;

// Longueur (en pixel) d'un millimètre pour l'écran utilisé
const pxMM = 5;

function chargerParticipant() {
	currentParticipant = getSelectedParticipant()
	participantTrials = loadParticipantTrials()
	trialIndex = 0
	loadTrial()
}

function trialSuivant() {
	/* TODO fonction à appeler pour passer au trial suivant.
		- Logguer les résultats
		- Vérifier qu'il ne s'agit pas du dernier trial pour ce participant
		- Nettoyer le canvas
		- Générer un nouveau canvas à partir des paramètres du trial
	*/
	logTrial(participantTrials[trialIndex]);
	clearCanvas();
	if(trialIndex >= participantTrials.length-1) {
		alert("FIN pour le participant " + currentParticipant);
	}
	trialIndex++;
	loadTrial();
}



// FONCTIONS UTILITAIRES

function loadTrial() {
	clearCanvas();
	writeTrialNumberInfo();

	const trial = participantTrials[trialIndex];
	Technique = trial.Technique;
	
	infos = drawScene(trial, 200, calculateX0(trial));
	findCible(infos);

	nbErrors = 0;

	// nouvelle date !!!
	startDate = new Date();
}

// Fonction qui désigne la cible à sélectionner parmis les distracteurs tracés
function findCible(infos) {
	let inLine;
	let inCol;

	if(infos.nbSquares % 2 == 1) {
		inLine =  ((infos.nbLines - 1) / 2) * infos.nbSquares;
		inCol = (infos.nbSquares - 1) / 2;
	}
	else {
		inLine = (infos.nbLines / 2) * infos.nbSquares
		inCol = (infos.nbSquares / 2) - 1
	}


	const indexCible = Math.round(inLine + inCol);
	CurrentTargets[indexCible].isDistractor = false;
	CurrentTargets[indexCible].defaultColor = TargetColor;
	CurrentTargets[indexCible].svg.fill(TargetColor)
}

/**
 * Fonction ayant pour but de calculer le x0 pour placer la scène du trial et le retourne
 * @param {any} trial 
 */
function calculateX0(trial) {
	// SI [c'est le premier trial que l'on gère] (le curseur n'est pas encore placé donc c'est un cas particulier)
	if(trialIndex == 0) {
		// je me place en fonction du sens de la scène qui va suivre
		return 100;
	}

	// distance du curseur requise
	const A = trial.Distance * pxMM
	let x0;
	// SI [il faut placer la scene à gauche]
	if(CurrentX < 800) {
		x0 = CurrentX + A
	}
	// SINON [il fajut placer la scène à droite]
	else {
		x0 = CurrentX - A
	}

	// Correction si jamais on dépasse l'écran
	if(x0 < 0) {
		x0 = 100;
	}
	if(x0 >= 1450) {
		x0 = 1200;
	}

	return x0;
}

/**
 * Fonction qui dessine le canvas à utiliser pour le trial courant
 * @param {*} trial 
 */
function drawScene(trial, y0, x0) {
	const T = trial.Taille * pxMM; // longueur d'un cube en px
	const D = (trial.Densite/100) * T; // distance D de la densité en px
	const zone = 500 + T; // taille de la zone où sont dessinés les cibles
	let y = y0;
	let nbLines = 0;
	let nbSquares = 0;
	let canDraw = true;
	while(canDraw) {
		nbSquares = drawRows(trial, y, x0);
		nbLines++;
		canDraw = y + T + D <= y0 + zone;
		y += D + T;
	}

	return {
		nbSquares,
		nbLines
	};
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
	let nbSquares = 0;

	// TANT QUE [je peux dessiner un carré]
	let canDraw = true;
	while(canDraw) {
		// ALORS [je dessine une target]
		new Target(x, y, T, true);
		nbSquares++;

		canDraw = x + T + D <= x0 + zone;
		x+= D + T;
	}
	return nbSquares;
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
				"Bloc": Trials["Bloc"][i],
				"Trial": Trials["Trial"][i],
			})
		}
	}

	return result;
}

function writeTrialNumberInfo() {
	document.getElementById('js-info-nombre-trial').innerText = 'Nombre de trials : ' + (trialIndex + 1) + ' / ' + participantTrials.length;
}