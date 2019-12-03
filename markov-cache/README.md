# TP : Chaînes de Markov cachées

**Auteur : BARCHID Sami**

Ce README contient les réponses des questions demandées lors de ce TP sur les chaînes de Markov.

## Modalités
- Dans le répertoire courant se trouvent les sources complétées du TP sur les chaînes de Markov cachées.
- Le fichier `gestures.xml` est le même que le fichier original, sauf qu'un pattern en plus a été ajouté (comme demandé à la question 9). La classe ajouté se nomme "**lune**" et ressemble à l'image ci-dessous. En gros, c'est un D majuscule... 

![lune exemple](img/exemple-lune.png)

- L'exécution du code peut se faire via la commande suivante (lorsque l'on se positionne sur le répertoire racine du projet) : `java -jar markov.jar`

- Le post-processing est activé dans le programme. Le programme est donc capable de discriminer des gestes aberrants. 

- Le programme `markov.jar` lit le fichier de gestes `resources/gestures.xml` situé à la racine du projet.

## Réponses aux questions du TP
Cette partie présente les réponses aux questions posées dans l'énoncé du TP.

#### Question 3
> "[...] Quels sont les défauts de la méthode d’extraction proposée ?"

La réflexion d'un geste par rapport à l'axe des X "trompe" la reconnaissance. C'est-à-dire que si je fais une réflexion d'une forme par rapport à l'axe des X, mon programme reconnaitra exactement la même forme que si c'était à l'endroit.

Un exemple de problème concret que ça engendrerait est : 
- je peux reconnaître la lettre "p" (en minuscule).
- je marque la lettre "q" (en minuscule toujours).
- ma reconnaissance trouvera la lettre "p" quand même car la forme de "q" est une réflexion de "p" par rapport à l'axe des X.

Donc dans le cas où on cherche à reconnaître des lettres, on a un gros problème car on ne désire strictement aucune invariance de la sorte.

#### Question 4
> "Lisez et comprenez les méthodes `computeKmeansLearner` et `trainHMM` de `GestureClass`."

Les deux méthodes se trouvent dans la classe `GestureClass`. Il est donc important de rappeler ce qu'est `GestureClass`. Notre programme de reconnaissance de gestes construit un HMM (hiden markov model) pour chaque classe de geste donnée (exemple : classe de geste "étoile", etc). `GestureClass` représente cette classe de geste ainsi que le HMM associé.

Les deux fonctions à expliquer sont les deux fonctions qui servent à entraîner le HMM de la classe de geste pour qu'il soit capable de reconnaître un geste (càd une séquence d'observations). On fournit tout d'abord à la `GestureClass` une liste de "templates" (ce sont des gestes d'exemple qui vont servir à l'apprentissage de la HMM). Ensuite on l'entraîne (via les deux méthodes à décrire pour cette question). Ensuite, il sera possible de calculer une probabilité qu'une séquence d'observations tracée appartienne au HMM en utilisant l'algorithme du forward-backward avec le HMM entraîné. 

- `computeKmeansLearner` : cette méthode va prendre chaque template d'entraînement fourni à la construction de la `GestureClass` et les transformer en séquences d'observations qui pourront être fournies au HMM pour son entraînement. Lorsque tous les templates ont été transformés en séquence d'observation, la méthode appelle `trainHMM`, que je vais décrire au point suivant.
- `trainHMM` : cette méthode prend en paramètre la liste de séquences d'observations trouvée avant et va entraîner le HMM de la `GestureClass`. La méthode entraîne en premier lieu le HMM grâce à l'algorithme K-means dont les k classes à définir sont le nombre d'états cachés du HMM. Ce nombre d'états cachés est à choisir avant l'entraînement. Après k-means, la méthode utilise l'algorithme de Baum-Welch avec le HMM entraîné via k-means. L'algorithme de Baum-Welch sert à rééstimer les paramètres d'un HMM afin de maximiser localement la probabilité d'une séquence d'observation à appartenir au HMM. C'est pourquoi il est important de fournir à l'algorithme de Baum-Welch un HMM qui est déjà pré-entrainé. 

   

#### Question 7
> "La post-traitement permet de détecter les faux positifs: par exemple un geste tracé qui n’a rien à voir avec les différentes classes de gestes. Une première solution consiste à mettre un seuil sur la probabilité calculée. Une seconde solution consiste à calculer des caractéristiques globales sur le geste (distance entre premier point et dernier point par exemple) et ensuite déterminer si elles sont valides. Compte tenu des valeurs de probabilités la première solution n’est pas viable. Testez la seconde solution."

Le code du post processing est le suivant :

```java
	/**
	 * Effectue le post-processing en comparant les distances du premier au dernier
	 * point pour la séquence observée (resampledPoints) et celle de la GestureClass
	 * 
	 * @param g
	 * @return true si la gestureClass passe le test de distance des points
	 *         normalisés
	 */
	private boolean postProcessing(GestureClass g) {
		// Distance normalisée de la séquence observée
		double distObservee = this.getDistanceNormalisee(this.resampledRawPoints);

		// POUR CHAQUE template de la GestureClass
		for (Template t : g.examples) {
			Vector<Point2D> templatePoints = new Vector<Point2D>();
			for (PointData pd : t.getPoints()) {
				templatePoints.add(pd.getPoint());
			}

			double distTemplate = this.getDistanceNormalisee(templatePoints);

			// La distance des points normalisés de la séquence observée doit être celle de
			// la distance normalisée du template (à un dixième près)
			if (distObservee >= distTemplate - 0.1 && distObservee <= distTemplate + 0.1) {
				return true;
			}
		}

		return false;
	}
```

Avant d'expliquer ce que fait la méthode, je dois expliquer ce qu'est ma notion de "distance normalisée". Ici, la "distance normalisée" est calculée de la sorte :
- Dans ma liste de points approximée (correspondant à la liste de `Point2D` calculée dans la méthode `resample()`), je cherche les valeurs de X et Y qui sont minimales et maximales.
- Je prend le point de début de geste et le point de fin du geste.
- Je modifie les coordonnées de ces deux points pour les normaliser entre 0 et 1 par rapport aux minimaux et maximaux que j'ai trouvé auparavant.
- Je calcule la distance entre les points de début et de fin modifiés (coordonnées entre 0 et 1). Ceci me donne la distance normalisée.

Avec cette notion de distance normalisée, mon post-processing consiste à :
- Pour chaque template de la classe à tester, je vérifie que la distance normalisée du geste à tester est égal à la distance normalisée du template au dixième près. Si ce n'est pas le cas pour aucun des templates, c'est que la classe testée n'a aucun rapport avec le geste à tester.

Ce post-processing permet de discriminer de manière assez efficace les cas où, par exemple, certains gestes commencent et se terminent quasiment au même endroit (par exemple, le cercle).

Je justifie le fait d'utiliser cette notion de distance normalisée par le fait que, grâce à ça, on ne se soucie plus de la taille de notre geste. En effet, sans normalisation, le fait de tracer une petite accolade ou une grosse aurait changé le résultat puisque la distance aurait été plus petite pour une petite accolade par rapport à une grande. Grâce à la distance normalisée, on ne se soucie plus de la distance effective mais surtout des proportions par rapport au geste lui-même.

Lors de mes tests, j'ai remarqué que le post-processing permet de différencier fortement les cas où les points de début et de fin sont fort rapprochés par rapport aux cas où ces points sont éloignés, ce qui amène une petite amélioration.

On verra, dans la question suivante (question 8), que ce post-processing apporte une très petite amélioration du taux de reconnaissance.  

#### Question 8
> Jouez avec le nombre d’état cachés des chaînes de Markov, le pas de temps pour le ré-échantillionnage et le calcul des caractéristiques pour observer les résultats sur les performances de reconnaissance. Quelle est l’influence de ces différents paramètres, comment les optimiser? La méthode `TestAllExamples` de `HMM` peut aider à répondre à cette question.

Le fichier `resultats-reglages.ods` se trouvant à la racine du projet fourni une table "libre office calculator" avec les différens paramètres que j'ai fait varier. Les paramètres que j'ai fait varier sont :
- le delta de temps (en milisecondes) pour l'échantillonnage.
- le nombre d'états cachés des HMM.
- L'activation du post-processing.

J'ai alors cherché à comparer ces paramètres en utilisant le taux de reconnaissance donné grâce à la méthode `TestAllExamples`.

Avec ces variations de paramètres, j'ai pu faire les observations suivantes :
- Le taux de reconnaissance est généralement haut (presque 95% au maximum).
- L'utilisation de ma méthode de post-processing permet d'améliorer très légérement le taux de reconnaissance. Il faut quand même noter que, parfois, le post-processing n'améliore aucunement la reconnaissance.
-  Pour le même pas d'échantillon (20ms), j'ai fait varier le nombre d'états cachés. Il s'est avéré que, pour ce même pas d'échantillonnage, il y a un (ou plusieurs) nombre d'états cachés qui fournissent le meilleur taux. Un nombre plus petit ou plus grand que ce nombre d'états cachés optimale donne des taux plus petits. Voir l'image ci-dessous pour comprendre. (Attention : sur l'image, l'axe des X n'est pas trié de manière croissante).

![graphique 20ms](img/taux-reco-20-ms.png)

- Un pas d'échantillonnage trop grand (par exemple, 100ms) peut tromper le post-processing. En effet, dans l'exemple de l'échantillonnage des 100ms, l'activation du post-processing a fait chuté le taux de reconnaissance de 5%. C'est dû au fait que les points échantillonnés ont produit une distance entre le premier et le dernier point trop grande, qui a dû forcer le post-processing a discriminé des séquences d'observation qui étaient pourtant bonnes.

- Cependant, pour un pas d'échantillonnage très court (ici, 1ms, c'est-à-dire pas d'échantillonnage finalement), le post-processing est très efficace car son pouvoir de discrimination est plus précis.

- Pour un pas d'échantillon court (1 ms ici), le nombre d'états cachés qui fournissent un taux optimal est plus grand. En d'autres termes, plus le pas d'échantillonnage est court, plus le nombre d'états cachés doit être grand pour obtenir un taux de reconnaissance optimal. 

- On peut aussi formuler ça de la manière suivante : pour un haut nombre d'états cachés, le pas d'échantillonnage doit être plus précis. (voir image ci-dessous).

![graphique 20 hidden](img/taux-reco-20-hidden.png)