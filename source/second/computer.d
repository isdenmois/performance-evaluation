module second.computer;
import second.component;
import second.task;
import std.container.dlist;
import std.algorithm.mutation;
import std.typecons;
import std.conv;

class Computer {
	public uint resource;
	private uint size;

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
			currentTasks ~= buffer.back;
			buffer.removeBack;
			count++;
		}

		return count;
	}

	public Task[] tick() {
		Task[] result;
		int[] toDelete;

		foreach(i, task; this.currentTasks) {
			if (task.tick() !is null) {
				result ~= task;
				toDelete ~= i;
			}
		}
		currentTasks.remove(toDelete);
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
	Task t = new Task();
	t.addComponent(1, 1);
	Task t1 = new Task();
	t1.addComponent(1, 2);
	Task t2 = new Task();
	t2.addComponent(1, 2);
	Task t3 = new Task();
	t3.addComponent(1, 1);
	Task t4 = new Task();
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
	assert(ended.length == 2);

	ended = c.tick;
	assert(c.currentTaskCount == 1);
	assert(ended.length == 3);

	ended = c.tick;
	assert(c.currentTaskCount == 1);
	assert(ended.length == 0);

	ended = c.tick;
	assert(c.currentTaskCount == 0);
	assert(ended.length == 1);

}
