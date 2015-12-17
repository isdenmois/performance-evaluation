module source.server;
import second.task;
import second.computer;

class server {
	Computer[] computers;

	this() {
		computers ~= Computer(1, 1);
		computers ~= Computer(2, 2);
		computers ~= Computer(3, 3);
		computers ~= Computer(4, 1);
		computers ~= Computer(5, 2);
	}

	void addTask(Task t) {

	}
}
