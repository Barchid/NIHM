/**
 * GestureProbability.java
 *
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 * @version
 */

public class GestureProbability implements Comparable<GestureProbability> {
	String name;
	double pi; // probability
	
	public GestureProbability(String name, double pi) {
		this.name = name;
		this.pi = pi;
	}

	public int compareTo(GestureProbability o) {
		if (pi < ((GestureProbability)o).pi) return 1;
		else return -1;
		//return 0;
	}
	
	String getName() {
		return name;
	}
	
	double getPi() {
		return pi;
	}

}