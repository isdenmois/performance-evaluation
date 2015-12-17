module second.second;
import randoms;
import second.task;
import second.server;

string second_process(uint k, double task, double[5][] params) {
	Random task_stream = new Exponential(task);
	Random first_stream = new GaussianAbs(params[0][0], params[0][1]);
	Random second_stream = new Rayleigh(params[1][0]);
	Random third_stream = new E3(params[2][0]);
	Random fourth_stream = new Lognormal(params[3][0], params[3][1]);
	Random fifth_stream = new Lognormal(params[4][0], params[4][1]);

	Server server = new Server();
	double next_task = task_stream.next;
	double[] w;
	StopWatch sw;

	sw.start();
	for (int time = 0; k > 0; time++, next_task--, k--) {
		Task[] task = server.tick;

		if (task.length > 0) {
			k -= task.length;
			// TODO: Обработка w.
		}

		if (next_task <= 0) {
			next_task = task_stream.next;

			Task task = new Task();
			task.addComponent(1, first_stream.next);
			task.addComponent(3, second_stream.next);
			task.addComponent(2, third_stream.next);
			task.addComponent(4, fourth_stream.next);
			task.addComponent(2, fifth_stream.next);
			server.addTask(task);
		}
	}

	JSONValue result = [
		"result": "success",
	];
	result.object["w"] = convertList(w);
	sw.stop;
	result.object["time"] = JSONValue(sw.peek().msecs.to!string);

	return result.toString;
}
