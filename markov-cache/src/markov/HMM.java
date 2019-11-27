package markov;
/**
 * HMM.java
 *
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 * @version
 */

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Vector;
import java.util.stream.Collectors;

import javafx.geometry.Point2D;

public class HMM {
	private Vector<PointData> rawSrcPoints;
	private double score = 0;
	private String nameTemplateFound = "none";
	private Vector<Point2D> resampledRawPoints;

	/**
	 * List all the gestures classes (name of the templates)
	 */
	Vector<String> gestureClasses;

	/**
	 * Hash map that gathers all the information on a class
	 */
	HashMap<String, GestureClass> classMap;

	TemplateManager templateManager;

	Vector<GestureProbability> gesturesProbabilities;

	int cpt = 0;
	int resamplingPeriod = 20;

	HMM() {
		gestureClasses = new Vector<String>();
		classMap = new HashMap<String, GestureClass>();
		templateManager = new TemplateManager("ressources/gestures.xml");
		gesturesProbabilities = new Vector<GestureProbability>();
		Training();
	}

	/**
	 * Training step
	 */
	public void Training() {
		// templates : list of all the templates of each class
		Vector<Template> templates = templateManager.getTemplates();

		// Computes the features for each example (template)
		for (int i = 0; i < templates.size(); i++) {
			templates.get(i).setFeatures(computeFeatures(resample(templates.get(i).getPoints(), resamplingPeriod)));
		}

		// gestureClasses : list of all the gesture classes
		for (int i = 0; i < templates.size(); i++)
			gestureClasses.add(templates.get(i).getName());
		Collections.sort(gestureClasses);
		// Remove duplicates
		int i = 1;
		while (i < gestureClasses.size()) {
			if (gestureClasses.get(i).compareTo(gestureClasses.get(i - 1)) == 0)
				gestureClasses.remove(i);
			else
				i++;
		}

		System.out.println("Liste des classes : " + gestureClasses.toString());

		// Gather the templates
		for (i = 0; i < gestureClasses.size(); i++) {
			String className = gestureClasses.get(i);
			Vector<Template> classExamples = new Vector<Template>();
			for (int j = 0; j < templates.size(); j++)
				if (templates.get(j).getName().compareTo(className) == 0)
					classExamples.add(templates.get(j));
			GestureClass gestureClass = new GestureClass(classExamples, className);
			classMap.put(className, gestureClass);
		}

		// gestureClasses.remove("arrow");
		// gestureClasses.remove("leftCurlyBrace");
		// gestureClasses.remove("pigtail");
		// gestureClasses.remove("rightCurlyBrace");
		// System.out.println("Liste des classes : " + gestureClasses.toString());

		// KMeansLearner
		for (int c = 0; c < gestureClasses.size(); c++) {
			classMap.get(gestureClasses.get(c)).computeKmeansLearner();
		}

		// Print hmm for each gesture class
		/*
		 * for (int c=0; c<gestureClasses.size();c++) { try { (new
		 * GenericHmmDrawerDot()).write(classMap.get(gestureClasses.get(c)).getHMM(),
		 * gestureClasses.get(c)+".dot");
		 * Runtime.getRuntime().exec("/usr/local/bin/dot -Tpdf " +
		 * gestureClasses.get(c)+".dot" + " -o " + gestureClasses.get(c)+".pdf"); }
		 * catch (IOException e) { // TODO Auto-generated catch block
		 * e.printStackTrace(); } } try { Runtime.getRuntime().exec("shutdown -r -t 1 "
		 * ); } catch (IOException t) { }
		 */
	}

	public void recognize() {

		gesturesProbabilities.clear();

		if (rawSrcPoints.size() < 4)
			return;
		ArrayList<Double> featuresRawPoints = computeFeatures(resample(rawSrcPoints, resamplingPeriod));
		score = Double.MIN_VALUE;
		nameTemplateFound = "none";
		for (int c = 0; c < gestureClasses.size(); c++) {
			GestureClass g = classMap.get(gestureClasses.get(c));
			double scoreClass = g.computeScore(featuresRawPoints);
			// System.out.println(gestureClasses.get(c) + " " + scoreClass);

			boolean isOk = this.postProcessing(g);

			// SI [je ne passe pas le post processing]
			if (!isOk) {
				// ALORS [j'évite le faux positif]
				System.out.println("\n" + g.gestureClassName + " --> NON");
				continue;
			} else {
				System.out.println("\n" + g.gestureClassName + " --> OUI");
				
				// Ajouter la proba si elle a passé le post process 
				gesturesProbabilities.add(new GestureProbability(g.gestureClassName, scoreClass));
				if (scoreClass > score) {
					score = scoreClass;
					nameTemplateFound = gestureClasses.get(c);
				}
			}
		}
		Collections.sort(gesturesProbabilities);

		// System.out.println("Classe = " + nameTemplateFound + " " + score);

	}

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
		System.out.println("Observee norm " + distObservee);

		// POUR CHAQUE template de la GestureClass
		for (Template t : g.examples) {
			Vector<Point2D> templatePoints = new Vector<Point2D>();
			for (PointData pd : t.getPoints()) {
				templatePoints.add(pd.getPoint());
			}

			double distTemplate = this.getDistanceNormalisee(templatePoints);
			System.out.println("dist tmplt pour " + g.gestureClassName + " : " + distTemplate);

			// La distance des points normalisés de la séquence observée doit être celle de
			// la distance normalisée du template (à un dixième près)
			if (distObservee >= distTemplate - 0.1 && distObservee <= distTemplate + 0.1) {
				return true;
			}
		}

		return false;
	}

	/**
	 * Retourne la distance normalisee entre 0 et 1 de la séquence de points
	 * observés
	 * 
	 * @param points
	 * @return
	 */
	private double getDistanceNormalisee(Vector<Point2D> points) {
		// récupérer les limites du pattern
		double minX = points.firstElement().getX();
		double maxX = points.firstElement().getX();
		double minY = points.firstElement().getY();
		double maxY = points.firstElement().getY();
		for (Point2D pt : points) {
			double y = pt.getY();
			double x = pt.getX();

			if (x < minX)
				minX = x;
			if (y < minY)
				minY = y;
			if (x > maxX)
				maxX = x;
			if (y > maxY)
				maxY = y;
		}

		Point2D first = points.firstElement();
		Point2D last = points.lastElement();

		Point2D mappedFirst = new Point2D(this.normalize(first.getX(), minX, maxX),
				this.normalize(first.getY(), minY, maxY));

		Point2D mappedLast = new Point2D(this.normalize(last.getX(), minX, maxX),
				this.normalize(last.getY(), minY, maxY));

		return this.distance(mappedFirst, mappedLast);
	}

	/**
	 * Calculates a value between 0 and 1, given the precondition that value is
	 * between min and max. 0 means value = max, and 1 means value = min.
	 */
	double normalize(double value, double min, double max) {
		return ((value - min) / (max - min));
	}

	public Vector<String> getRecognitionInfo() {
		Vector<String> res = new Vector<String>();
		int cpt = 1;
		for (int i = 0; i < gesturesProbabilities.size(); i++) {
			if (gesturesProbabilities.get(i).getPi() > 0) {
				res.add(cpt + ". " + gesturesProbabilities.get(i).getName() + " "
						+ gesturesProbabilities.get(i).getPi());
				cpt++;
			}
		}
		if (nameTemplateFound.compareTo("none") != 0) {
			Vector<String> obsVectors = classMap.get(nameTemplateFound).getObservationVectors();

			res.add("");
			res.add("Sequence d'observation:");
			DecimalFormat format = new DecimalFormat("#0");
			format.setMinimumIntegerDigits(2);
			ArrayList<Double> featuresRawPoints = computeFeatures(resample(rawSrcPoints, resamplingPeriod));
			String tmp = "";
			for (Double i : featuresRawPoints) {
				tmp += format.format(i.intValue()) + " ";
			}
			res.add(tmp);

			res.add("");
			res.add("Sequences d'observations pour le geste " + nameTemplateFound + ":");
			res.addAll(obsVectors);
		}

		return res;
	}

	public double getScore() {
		return score;
	}

	public String getNameTemplateFound() {
		return nameTemplateFound;
	}

	public void setRawSourcePoints(Vector<PointData> rawPoints) {
		/*
		 * writeRawPoints2XMLFile("soleil",rawSrcPoints); cpt++;
		 * System.out.println(cpt);
		 */

		rawSrcPoints = rawPoints;
		resampledRawPoints = resample(rawPoints, resamplingPeriod);
	}

	public void TestAllExamples() {
		int cpt = 0;
		int good = 0;
		for (int c = 0; c < gestureClasses.size(); c++) {
			GestureClass gestClass = classMap.get(gestureClasses.get(c));
			for (int i = 0; i < gestClass.getNumberExamples(); i++) {
				rawSrcPoints = gestClass.examples.get(i).getPoints();
				recognize();
				if (gestureClasses.get(c).compareTo(getNameTemplateFound()) == 0)
					good++;
				else
					System.out.println("Bad - " + gestureClasses.get(c) + " example num " + i);
				cpt++;
			}
		}
		System.out.println("Recognition rate of examples = " + good / (cpt * 1.0));
		// rawSrcPoints = classMap.get("check").examples.get(tmpCpt).getPoints();
	}

	/**
	 * Compute features
	 */

	public ArrayList<Double> computeFeatures(Vector<Point2D> points) {
		ArrayList<Double> features = new ArrayList<Double>();

		// Vide si pas au moins deux points
		if (points.size() <= 1) {
			return features;
		}

		// point précédent pour calculer l'angle
		Point2D precedent = points.get(0);

		// POUR CHAQUE [point]
		for (int i = 1; i < points.size(); i++) {
			Point2D courant = points.get(i);

			// CALCULER [la feature à base de l'angle entre la droite precedent-courant et
			// l'horizontle
			double feature = this.angleFeature(precedent, courant);

			// AJOUTER aux features
			features.add(feature);

			// Précédent devient le courant pour le prochain point
			precedent = courant;
		}

		return features;
	}

	/**
	 * Donne la valeur absolue de l'angle formé par la droite AB et l'horizontal à
	 * 10 degrés près
	 * 
	 * @param a
	 * @param b
	 * @return valeur absolue de l'angle à 10 degrés près (de 0 à 180)
	 */
	private double angleFeature(Point2D a, Point2D b) {
		return Math.round(Math.abs(Math.toDegrees((Math.atan2(b.getY() - a.getY(), b.getX() - a.getX()))))) / 10;
	}

	/**
	 * Add new gestures to out.xml XML file. Then copy and paste the data in out.xml
	 * file to gestures.xml file
	 * 
	 * @param points
	 */
	public void writeRawPoints2XMLFile(String name, Vector<PointData> points) {
		try {
			FileWriter fstream = new FileWriter("out.xml", true);
			BufferedWriter out = new BufferedWriter(fstream);
			out.write("	<template name=\"" + name + "\" nbPts=\"" + points.size() + "\">\n");
			for (int i = 0; i < points.size(); i++) {
				out.write("		<Point x=\"" + points.get(i).getPoint().getX() + "\" y=\""
						+ points.get(i).getPoint().getY() + "\" ts=\"" + points.get(i).getTimeStamp() + "\"/>\n");
				// if (i<points.size()-1) System.out.print(",");
			}

			out.write("	</template>\n");
			out.close();
		} catch (Exception e) {// Catch exception if any
			System.err.println("Error: " + e.getMessage());
		}

	}

	/**
	 * Distance between two points
	 * 
	 * @param p0
	 * @param p1
	 * @return
	 */
	public double distance(Point2D p0, Point2D p1) {
		return Math.sqrt(
				(p1.getX() - p0.getX()) * (p1.getX() - p0.getX()) + (p1.getY() - p0.getY()) * (p1.getY() - p0.getY()));
	}

	public double squareDistance(Point2D p0, Point2D p1) {
		return (p1.getX() - p0.getX()) * (p1.getX() - p0.getX()) + (p1.getY() - p0.getY()) * (p1.getY() - p0.getY());
	}

	/**
	 * Resample points to have one point each deltaTms ms
	 * 
	 * @param p0
	 * @param p1
	 * @return
	 */

	protected Vector<Point2D> resample(Vector<PointData> pts, int deltaTms) {
		Vector<Point2D> res = new Vector<Point2D>();
		if (pts.size() == 0) {
			return res;
		}

		long currentInterval = pts.get(0).getTimeStamp();
		double sumX = 0;
		double sumY = 0;
		int nbPtInterval = 0; // nombre de point dans l'intervalle de temps deltaMS

		// POUR CHAQUE [point] (ils sont déjà triés par timestamp)
		for (PointData pt : pts) {
			// SI [on est toujours dans l'intervalle deltaMS]
			if (pt.getTimeStamp() <= currentInterval + deltaTms) {
				sumX += pt.getX();
				sumY += pt.getY();
				nbPtInterval++;
			}
			// SINON [on calcule la moyenne de tous les points]
			else {
				Point2D resampledPoint = new Point2D((sumX / nbPtInterval), (sumY / nbPtInterval));
				res.add(resampledPoint);

				// CREER [le prochain intervalle] AVEC [le point courant]
				sumX = pt.getX();
				sumY = pt.getY();
				currentInterval = pt.getTimeStamp();
				nbPtInterval = 1;
			}
		}

		// Ajout du dernier point (dans le cas où l'intervalle ne se finit pas dans la
		// boucle)
		Point2D resampledPoint = new Point2D((sumX / nbPtInterval), (sumY / nbPtInterval));
		res.add(resampledPoint);

		return res;
	}

	public Vector<Point2D> getResampledPoints() {
		return resampledRawPoints;
	}
}
