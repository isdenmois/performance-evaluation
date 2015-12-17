module second.task;
import second.component;
import std.container.dlist;

class Task {
	private DList!Component components;

	/**
	 * Create and insert new component.
	 */
	void addComponent(uint resource, double sigma) {
		this.components.insert(new Component(resource, sigma));
	}

	/**
	 * Calculate next state.
	 */
	Task tick() {
		if (!this.components.empty) {
			if (this.components.front.tick <= 0) {
				this.components.removeFront;
				return this;
			}
		}

		if (this.components.empty) {
			return this;
		}
		return null;
	}

	/**
	 * Calculate current resource type.
	 */
	uint type() {
		if (this.components.empty) {
			return 0;
		}
		return this.components.front.type;
	}
}

unittest {
	Task t = new Task();
	t.addComponent(1, 1);
	t.addComponent(2, 3);
	t.addComponent(3, 1);
	t.addComponent(1, 1);

	assert(t.type == 1);

	assert(t.tick !is null);
	assert(t.type == 2);

	assert(t.tick is null);
	assert(t.type == 2);

	assert(t.tick is null);
	assert(t.type == 2);

	assert(t.tick !is null);
	assert(t.type == 3);

	assert(t.tick !is null);
	assert(t.type == 1);

	assert(t.tick !is null);
	assert(t.type == 0);
}
