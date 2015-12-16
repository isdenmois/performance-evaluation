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

unittest {
	Task t = new Task(3, 10);
	assert(t.tick == 2);
	assert(t.tick == 1);
	assert(t.tick <= 0);
	assert(t.sigma == 3);
	assert(t.startTime == 10);

	assert(t.i == 0);
	assert(new Task(1, 1).i == 1);

	t = new Task(8, 1);
	assert(t.i == 2);

	Task t1 = new Task(10, 10);
	assert(t1.i == 3);

	assert(t.sigma == 8);
	assert(t.tick == 7);
	assert(t1.sigma == 10);

	t = new Task(1.1, 5);
	t.tick;
	assert(t.tick < 0);
	
	t = new Task(1.0, 5);
	t.tick;
	assert(t.tick <= 0);
}
