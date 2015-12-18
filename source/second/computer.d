module second.computer;
import second.component;
import second.task;
import std.container.dlist;

class Computer {
	public uint resource;
	private uint size;
	public double load;

	private DList!Task buffer;
	private Task[] currentTasks;

	this(uint resource, uint size) {
		this.resource = resource;
		this.size = size;
	}

	public bool addTask(Task task) {
		if (currentTasks.length < size) {
			this.currentTasks ~= task;
			return true;
		}

		this.buffer.insert(task);
		return false;
	}

	private uint moveFromBuffer() {
		uint count = 0;
		while (currentTasks.length < size && !buffer.empty) {
			currentTasks ~= buffer.front;
			buffer.removeFront;
			count++;
		}

		return count;
	}

	public Task[] tick() {
		Task[] result;
		Task[] newResult;
		this.load += this.currentTasks.length / this.size;

		foreach(i, task; this.currentTasks) {
			if (task.tick() !is null) {
				result ~= task;
			}
			else {
				newResult ~= task;
			}
		}
		currentTasks = newResult;
		moveFromBuffer();
		return result;
	}

	public int currentTaskCount() {
		return currentTasks.length;
	}
}

unittest {
	// Create test data.
	Computer c = new Computer(1, 3);
	Task t = new Task(3);
	t.addComponent(1, 1);
	Task t1 = new Task(4);
	t1.addComponent(1, 2);
	Task t2 = new Task(5);
	t2.addComponent(1, 2);
	Task t3 = new Task(5);
	t3.addComponent(1, 1);
	Task t4 = new Task(6);
	t4.addComponent(1, 2);

	// Test addition.
	assert(c.addTask(t));
	assert(c.addTask(t1));
	assert(c.addTask(t2));
	assert(c.addTask(t3) == false);
	assert(c.addTask(t4) == false);

	//Test ticks.
	Task[] ended = c.tick;
	assert(c.currentTaskCount == 3);
	assert(ended.length == 1);

	ended = c.tick;
	assert(c.currentTaskCount == 1);
	assert(ended.length == 3);

	ended = c.tick;
	assert(c.currentTaskCount == 1);
	assert(ended.length == 0);

	ended = c.tick;
	assert(c.currentTaskCount == 0);
	assert(ended.length == 1);

	ended = c.tick;
	assert(c.currentTaskCount == 0);
	assert(ended.length == 0);
}
