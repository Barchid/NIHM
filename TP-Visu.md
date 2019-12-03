# Choix 

- Plus c'est grand, plus surface est grande
- Variation de couleur pour représenter la population
	- la couleur varie suivant la valeur de la teinte (hue) dans l'espace de couleur HSB, c'est-à-dire que :
		- la couleur évolue du rouge (hue = 0%) au bleu (hue = 255°), en passant par le jaune, le vert etc
		- voir color picker pour piger
- classification par forme  :
	- S'inspirer de la classification faite par l'INSEE pour les unités urbaines (https://fr.wikipedia.org/wiki/Ville#Par_le_statut_ou_des_crit%C3%A8res_d'urbanisation)
	- Ca stipule :
	> "Actuellement, les limites statistiques proposées par l'INSEE sont les suivantes : lorsque l'agglomération rassemble moins de 2 000 habitants, dont les constructions doivent être à moins de 200 m l'une de l'autre25, il s'agit d'un village ; entre 2 000 et 5 000 habitants, il s'agit d'un bourg ; entre 5 000 et 20 000 habitants, il s'agit d'une petite ville ; entre 20 000 et 50 000 habitants une ville moyenne, entre 50 000 et 200 000 habitants une grande ville ; au-delà, les géographes parlent de métropole."

- On propose un modèle simplifié :
- L'INSEE utilise la notion "d'agglomération" (plusieurs communes) et compte le nombre d'habitants de cette agglomération où chaque habitant ne peut pas être séparé de plus de 200m d'une autre construction.
- Dans mon modèle, je garde les mêmes limites statistiques en terme de population mais je simplifie en ne calculant la population que dans la même commune (pas de notion de distance entre les constructions)
- Je rajoute une classe : les "communes abandonnées".
  - Une commune fantôme est une commune qui possède moins de 10 habitants

- Pour choisir la forme, On propose de représenter :
  - crane : commune fantôme ( < 10 habitants)
  - cercle : village ( < 2000 habitants)
  - carré : bourg (2 - 5k habitants)
  - triangle : petite ville (5k - 20k) : 
  - losange : moyenne ville (20k - 50k)
  - hexagone : grande ville (50k - 200k)
  - étoile : métropole (> 200k habitants)


- Choix visualisation :
  - Choix 1 :
    - Taille = population
    - Hue = altitude
    - Formes pour catégories urbaines
    - --> taille peu pertinente, on ne sait plus distinguer les catégories urbaines dans les petites régions car ça se chevauche et tout
    - --> Solution envisagée : laisser tomber formes pour cartes globales et reporter une carte zoomée
