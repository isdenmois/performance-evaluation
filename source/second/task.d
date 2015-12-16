module second.task;
import second.component;

class Task {
	Component[] components;

	void addComponent(uint resource, double sigma) {
		this.components ~= new Component(resource, sigma);
	}
}