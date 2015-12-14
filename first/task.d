module first.task;

class Task {
	private double time;
  	public double sigma;

	public uint startTime;

	private static int count = 0;
	public int i;

	this(double sigma, int startTime) {
		this.sigma = sigma;
		this.time = sigma;
		this.startTime = startTime;
		this.i = this.count++;
	}

	double tick() {
		return --this.time;
	}
}