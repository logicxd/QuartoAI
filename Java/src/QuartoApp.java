import javax.swing.SwingUtilities;

public class QuartoApp {
	public static void main(String[] args) {
		SwingUtilities.invokeLater(new Runnable() {
			@Override
			public void run() {
				new QuartoBoard();
			}
		});
	}

}
