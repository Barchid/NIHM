/**
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 */

import java.io.File;
import java.util.Vector;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class TemplateManager
{
	private Vector<Template> theTemplates;
	
	TemplateManager(String filename) {
		theTemplates = new Vector<Template>();
		loadFile(filename);
	}
	
	void loadFile(String filename) {
		File fXmlFile = new File(filename);
		DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
		DocumentBuilder dBuilder;
		Document doc;
		
		try {
			dBuilder = dbFactory.newDocumentBuilder();
			doc = dBuilder.parse(fXmlFile);
			doc.getDocumentElement().normalize();
			NodeList nList = doc.getElementsByTagName("template");
			for (int i = 0; i < nList.getLength(); i++) {
				Node nNode = nList.item(i);
				Element eElement = (Element) nNode;
				String name = eElement.getAttribute("name").toString();
				
				Vector<PointData> pts = new Vector<PointData>();
				
				NodeList nListPoints = eElement.getElementsByTagName("Point");
				for (int j = 0; j < nListPoints.getLength(); j++) {
					Node nNodepoints = nListPoints.item(j);
					Element eElementPoint = (Element) nNodepoints;
					double x = Double.parseDouble(eElementPoint.getAttribute("x").toString());
					double y = Double.parseDouble(eElementPoint.getAttribute("y").toString());
					long ts = Long.parseLong(eElementPoint.getAttribute("ts").toString());
					pts.add(new PointData(x, y, ts));
				}
				theTemplates.add(new Template(name, pts));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	Vector<Template> getTemplates() {
		return theTemplates;
	}
}