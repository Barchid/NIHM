# TP : Chaînes de Markov cachées

**Auteur : BARCHID Sami**

Ce README contient les réponses des questions demandées lors de ce TP sur les chaînes de Markov.

## Modalités
- Dans le répertoire courant se trouvent les sources complétées du TP sur les chaînes de Markov cachées.
- Le fichier `gestures.xml` est le même que le fichier original, sauf qu'un pattern en plus a été ajouté (comme demandé à la question 9). La classe ajouté se nomme "**lune**" et ressemble à l'image ci-dessous. En gros, c'est un D majuscule... 

![lune exemple](img/exemple-lune.png)

- L'exécution du code peut se faire via la commande suivante (lorsque l'on se positionne sur le répertoire racine du projet) : `java -jar markov.jar`

- Le post-processing est activé dans le programme.

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



#### Question 7
> "La post-traitement permet de détecter les faux positifs: par exemple un geste tracé qui n’a rien à voir avec les différentes classes de gestes. Une première solution consiste à mettre un seuil sur la probabilité calculée. Une seconde solution consiste à calculer des caractéristiques globales sur le geste (distance entre premier point et dernier point par exemple) et ensuite déterminer si elles sont valides. Compte tenu des valeurs de probabilités la première solution n’est pas viable. Testez la seconde solution."

Le code du post processing est le suivant :

```java
	/**
	 * Effectue le post-processing en comparant les distances du premier au dernier
	 * point pour la s�quence observ�e (resampledPoints) et celle de la GestureClass
	 * 
	 * @param g
	 * @return true si la gestureClass passe le test de distance des points
	 *         normalis�s
	 */
	private boolean postProcessing(GestureClass g) {
		// Distance normalis�e de la s�quence observ�e
		double distObservee = this.getDistanceNormalisee(this.resampledRawPoints);

		// POUR CHAQUE template de la GestureClass
		for (Template t : g.examples) {
			Vector<Point2D> templatePoints = new Vector<Point2D>();
			for (PointData pd : t.getPoints()) {
				templatePoints.add(pd.getPoint());
			}

			double distTemplate = this.getDistanceNormalisee(templatePoints);

			// La distance des points normalis�s de la s�quence observ�e doit �tre celle de
			// la distance normalis�e du template (� un dixi�me pr�s)
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

