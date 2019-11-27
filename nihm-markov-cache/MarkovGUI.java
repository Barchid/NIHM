/**
 * @author <a href="mailto:gery.casiez@univ-lille1.fr">Gery Casiez</a>
 */

import java.util.Vector;

import javafx.application.Application;
import javafx.geometry.Point2D;
import javafx.scene.Scene;
import javafx.scene.canvas.Canvas;
import javafx.scene.canvas.GraphicsContext;
import javafx.scene.layout.VBox;
import javafx.scene.paint.Color;
import javafx.stage.Stage;

public class MarkovGUI extends Application{
	GraphicsContext gc;
	Canvas canvas;
	
	// Stroke to test
	private Vector<PointData> TStroke;
	
	// The points of TStroke resampled
	private Vector<Point2D> TresampledPoints;
	
	// Hidden Markov Model
	private HMM hmm;
	
	// Holds results to display on the interface
	private Vector<String> console;
	
	public void start(Stage stage) {
		TStroke = new Vector<PointData>();
		TresampledPoints = new Vector<Point2D>();
		
		hmm = new HMM();

		console = new Vector<String>();
		
		VBox root = new VBox();
		canvas = new Canvas (600, 700);
		gc = canvas.getGraphicsContext2D();
		root.getChildren().add(canvas);
		
		canvas.setOnMousePressed(e -> {
			TStroke.clear();
			TresampledPoints.clear();
			redrawMyCanvas();			
		});
		
		canvas.setOnMouseDragged(e -> {
			TStroke.add(new PointData(e.getX(), e.getY(), System.currentTimeMillis()));
			redrawMyCanvas();
		});
		
		canvas.setOnMouseReleased(e -> {
			if (!TStroke.isEmpty()) {
				hmm.setRawSourcePoints(TStroke);
				TresampledPoints = hmm.getResampledPoints();
				hmm.recognize();
				console = hmm.getRecognitionInfo();
				//hmm.TestAllExamples();
				redrawMyCanvas();
			}
		});

		Scene scene = new Scene(root);
		stage.setTitle("Université Lille 1 - M2 IVI - NIHM - HMM - G. Casiez");
		stage.setScene(scene);
		redrawMyCanvas();
		stage.show();
	}
	
	public void redrawMyCanvas() {
		gc.clearRect(0, 0, canvas.getWidth(), canvas.getHeight());
		gc.setFill(Color.BLACK);
		gc.fillText("Drag avec le bouton gauche ou droit de la souris : création d'une courbe de test",10,15); 
		int r = 5;  
		
		// Display the stroke
		if (!TStroke.isEmpty()) {
			gc.setStroke(Color.BLACK);
			for (int i = 1; i < TStroke.size(); i++) {
				gc.strokeLine(TStroke.get(i-1).getPoint().getX(), TStroke.get(i-1).getPoint().getY(),
						TStroke.get(i).getPoint().getX(), TStroke.get(i).getPoint().getY());
				gc.strokeOval(TStroke.get(i-1).getPoint().getX() - r,
						TStroke.get(i-1).getPoint().getY() - r, 2*r, 2*r);
			}
			gc.strokeOval(TStroke.get(TStroke.size()-1).getPoint().getX() - r,
					TStroke.get(TStroke.size()-1).getPoint().getY() - r, 2*r, 2*r);
		}
		
		// Display the console
		gc.setFill(Color.LIGHTGRAY);
		for (int i = 0; i < console.size(); i++) {
			gc.fillText(console.get(i),10,15*(i+2));			
		}
	
		// Display the resampled stroke
		if (!TresampledPoints.isEmpty()) {
			gc.setStroke(Color.RED);
			for (int i = 0; i < TresampledPoints.size(); i++) {
				gc.strokeOval(TresampledPoints.get(i).getX() - r, TresampledPoints.get(i).getY() - r, 2*r, 2*r);
			}
		}
	}

	public static void main(String[] args) {
		Application.launch(args);
	}
}
