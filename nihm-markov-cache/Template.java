/**
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 */

import java.util.ArrayList;
import java.util.Collection;
import java.util.Vector;

public class Template
{
	private String name;
	private Vector<PointData> points;
	private ArrayList<Double> features;
	
	Template( String name, Vector<PointData> points)
	{
		this.name = name;
		this.points = points;
	}
	
	public void setPoints(Vector<PointData> points) {
		this.points = points;
	}

	public Vector<PointData> getPoints() {
		return points;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	/**
	 * Features computed on the gesture
	 * @param arrayList
	 */
	public void setFeatures(ArrayList<Double> arrayList) {
		this.features = arrayList;
	}

	public ArrayList<Double> getFeatures() {
		return features;
	}
	
	public double[] getFeaturesDouble() {
		Collection<Double> val = features;
		double [] f = new double[val.size()];
		int j = 0;
		for (Double i : features) {
			f[j] = i;
			j++;
		}
		return f;
	}
	
	public Vector<Double> getFeaturesVector() {
		Vector<Double> f = new Vector<Double>();
		for (Double i : features) {
			f.add(i);
		}
		return f;
	}
}
