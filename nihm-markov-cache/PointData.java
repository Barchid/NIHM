/**
 * PointData.java
 *
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 * @version
 */

import javafx.geometry.Point2D;

public class PointData {
	private Point2D p;
	private long timeStamp;
	private double x;
	private double y;
	
	public PointData(Point2D p, long timeStamp) {
		this.p = p;
		this.timeStamp = timeStamp;
		x = p.getX();
		y = p.getY();
	}
	
	public PointData(PointData pt) {
		p = pt.getPoint();
		timeStamp = pt.getTimeStamp();
		x = pt.getX();
		y = pt.getY();
	}
	
	public PointData(double x, double y, long timeStamp) {
		this.x = x;
		this.y = y;
		this.timeStamp = timeStamp;
		p = new Point2D(x, y);
	}
	
	public Point2D getPoint() {
		return p;
	}
	
	public double getX() {
		return x;
	}
	
	public double getY() {
		return y;
	}
	
	public long getTimeStamp() {
		return timeStamp;
	}
}
