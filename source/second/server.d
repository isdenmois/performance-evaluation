module source.server;
import second.task;
import second.computer;

class server {
	Computer[] computers;

	this() {
		computers ~= new Computer(1, 1);
		computers ~= new Computer(2, 2);
		computers ~= new Computer(3, 3);
		computers ~= new Computer(4, 1);
		computers ~= new Computer(5, 2);
	}

	void addTask(Task t) {

	}
}
