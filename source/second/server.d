module second.server;
import second.task;
import second.computer;

class Server {
	Computer[] computers;

	this() {
		computers ~= new Computer(1, 1);
		computers ~= new Computer(2, 2);
		computers ~= new Computer(3, 3);
		computers ~= new Computer(4, 1);
		computers ~= new Computer(5, 2);
	}

	void addTask(Task task) {
		uint type = task.type;
		if (type <= this.computers.length && type > 0) {
			this.computers[type - 1].addTask(task);
		}
	}

	Task[] tick() {
		Task[] result;
		Task[] calculated;

		// Compute.
		foreach (computer; computers) {
			calculated ~= computer.tick;
		}

		// Reallocate.
		foreach (task; calculated) {
			if (task.type) {
				this.addTask(task);
			}
			else {
				result ~= task;
			}
		}

		return result;
	}
}

unittest {
	Server s = new Server();

	Task t1 = new Task();
	t1.addComponent(1, 2);
	t1.addComponent(2, 2);

	Task t2 = new Task();
	t2.addComponent(1, 2);
	t2.addComponent(2, 2);

	Task t3 = new Task();
	t3.addComponent(2, 1);
	t3.addComponent(1, 1);

	Task t4 = new Task();
	t4.addComponent(4, 1);

	Task t5 = new Task();
	t5.addComponent(5, 1);

	s.addTask(t1);
	s.addTask(t2);
	s.addTask(t3);
	s.addTask(t4);
	s.addTask(t5);

	Task[] ended;
	// Start: [1, 2 | 3 || 4 | 5]

	ended = s.tick; // -> [1, 2, 3 ||||] -> 4, 5
	assert(ended.length == 2);
	assert(ended[0] == t4);
	assert(ended[1] == t5);

	ended = s.tick; // -> [2, 3 | 1 |||]
	assert(ended.length == 0);

	ended = s.tick; // -> [2, 3 | 1 |||]
	assert(ended.length == 0);

	ended = s.tick; // -> [3 | 2 |||] -> 1
	assert(ended.length == 1);
	assert(ended[0] == t1);

	ended = s.tick; // -> [| 2 |||] -> 3
	assert(ended.length == 1);
	assert(ended[0] == t3);

	ended = s.tick; // -> [||||] -> 2
	assert(ended.length == 1);
	assert(ended[0] == t2);

	ended = s.tick; // -> [||||]
	assert(ended.length == 0);

}
