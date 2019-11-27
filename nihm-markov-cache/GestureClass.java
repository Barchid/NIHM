/**
 * HMM.java
 *
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 * @version
 */

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Vector;

import be.ac.ulg.montefiore.run.jahmm.ForwardBackwardCalculator;
import be.ac.ulg.montefiore.run.jahmm.Hmm;
import be.ac.ulg.montefiore.run.jahmm.ObservationInteger;
import be.ac.ulg.montefiore.run.jahmm.ObservationReal;
import be.ac.ulg.montefiore.run.jahmm.OpdfIntegerFactory;
import be.ac.ulg.montefiore.run.jahmm.learn.BaumWelchLearner;
import be.ac.ulg.montefiore.run.jahmm.learn.KMeansLearner;


public class GestureClass {
	// The templates (or examples) of the class of gesture
	Vector<Template> examples;
	KMeansLearner<ObservationInteger> kmeanslearner;
	
	// The Markov model associated to the class
	Hmm<ObservationInteger> hmm;
	
	ArrayList<ArrayList<ObservationInteger>> obsVectors;
	
	String gestureClassName;
	
	GestureClass(Vector<Template> examples, String name) {
		this.examples = examples;
		gestureClassName = name;
	}
	
	public int getNumberExamples() {
		return examples.size();
	}
	
	public Hmm<ObservationInteger> getHMM() {
		return hmm;
	}

	public void computeKmeansLearner() {
		obsVectors = new ArrayList<ArrayList<ObservationInteger>>();
		
		for (int i=0; i<examples.size(); i++) {
			ArrayList<ObservationInteger> obs = new ArrayList<ObservationInteger>();
			Vector<Double> f = examples.get(i).getFeaturesVector();
			for (int j=0; j<f.size(); j++) {
				obs.add(new ObservationInteger(f.get(j).intValue()));
			}
			obsVectors.add(obs);
		}
		
		//printObservationsSequences2(obsVectors);
				
		//kmeanslearner = new KMeansLearner(2, new OpdfIntegerFactory(19), obsVectors);
		//hmm = kmeanslearner.learn();
		hmm = trainHMM(obsVectors);
	}		
	
	public Hmm<ObservationInteger> trainHMM(ArrayList<ArrayList<ObservationInteger>> 
	obsVectors){
		//System.out.println(gestureClassName);
	        int numberOfHiddenStates = 2;
	        Hmm<ObservationInteger> trainedHmm;
	        do{
	            
	            KMeansLearner<ObservationInteger> kml = new 
	KMeansLearner<ObservationInteger>(numberOfHiddenStates, new OpdfIntegerFactory(19), obsVectors);

	            trainedHmm = kml.learn();
	            BaumWelchLearner bwl = new BaumWelchLearner();
	            bwl.setNbIterations(20);
	            trainedHmm = bwl.learn(trainedHmm, obsVectors);
	            numberOfHiddenStates++;
	        }while(Double.isNaN(trainedHmm.getPi(0)) && numberOfHiddenStates <50);
	        System.out.println("Number of hidden states for " + gestureClassName + " : " + (numberOfHiddenStates-1));

	        return trainedHmm;
	    }		
	
	public void printObservationsSequences(ArrayList<ArrayList<ObservationReal>> obsVectors) {
		for (ArrayList<ObservationReal> obs:obsVectors) {
			for (int i=0;i<obs.size();i++) {
				System.out.print(obs.get(i).value + " ");
			}
			System.out.println();
		}
		System.out.println();
	}
				
	public void printObservationsSequences2(ArrayList<ArrayList<ObservationInteger>> obsVectors) {
		for (ArrayList<ObservationInteger> obs:obsVectors) {
			for (int i=0;i<obs.size();i++) {
				System.out.print(obs.get(i).value + " ");
			}
			System.out.println();
		}
		System.out.println();
	}

	public Vector<String> getObservationVectors() {
		Vector<String> res = new Vector<String>();
		String tmp = "";
		DecimalFormat format = new DecimalFormat("#0");
		format.setMinimumIntegerDigits(2);
		for (ArrayList<ObservationInteger> obs:obsVectors) {
			tmp = "";
			for (int i=0;i<obs.size();i++) {
				tmp += format.format(obs.get(i).value) + " ";
			}
			res.add(tmp);
		}
		return res;
	}		
	
	public double computeScore(ArrayList<Double> featuresRawPoints) {
		double res = 0;
		
		ArrayList<ObservationInteger> obs = new ArrayList<ObservationInteger>();
		for (Double i : featuresRawPoints) {
			obs.add(new ObservationInteger(i.intValue()));
		}
				
		return res;
	}	
	
}	
