module second.second;
import randoms;
import second.task;
import second.server;
import std.json;
import std.datetime;
import std.conv;
import utils;

string second_process(uint k, double task_lambda, double TR1_mu, double TR1_sigma, double TR2, double TR3, double TR4_mu, double TR4_sigma, double TR5_mu, double TR5_sigma) {
	Random task_stream = new Exponential(task_lambda);
	Random first_stream = new GaussianAbs(TR1_mu, TR1_sigma);
	Random second_stream = new Rayleigh(TR2);
	Random third_stream = new E3(TR3);
	Random fourth_stream = new Lognormal(TR4_mu, TR4_sigma);
	Random fifth_stream = new Lognormal(TR5_mu, TR5_sigma);

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

			Task t = new Task();
			t.addComponent(1, first_stream.next);
			t.addComponent(3, second_stream.next);
			t.addComponent(2, third_stream.next);
			t.addComponent(4, fourth_stream.next);
			t.addComponent(2, fifth_stream.next);
			server.addTask(t);
			w ~= time;
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
