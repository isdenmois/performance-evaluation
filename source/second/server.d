module source.server;
import second.task;
import second.computer;

class server {
	Computer[] computers;
	this() {
		computers ~= Computer(1, 1);
		computers ~= Computer(2, 1);
		computers ~= Computer(3, 1);
		computers ~= Computer(4, 1);
	}
}
