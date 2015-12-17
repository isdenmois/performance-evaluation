module first.first;
import std.json;
import randoms;
import first.server;
import first.task;
import std.container;
import std.datetime;
import std.conv;
import std.math;
import utils;

string first_process(uint time, double lambda, double mean, double dev) {
	GaussianPlus potok = new GaussianPlus(mean, dev);
	Exponential waits = new Exponential(lambda);
	Server server = new Server;

	double next_task = potok.next;

	double[] length = [0];
	double[] delta = [];
	double[] pbusy = [];
	double[] sigma = [];

	bool flag = false;
	int currentTime = 0;

	int pbusySum = 0;
	int startTime = time;

	StopWatch sw;

	sw.start();
	while (time--) {
		if (server.isFree) {
			if (flag) {
				currentTime--;
				if (pbusy.length < currentTime + 1) {
					pbusy.length = currentTime + 1;
				}
				pbusy[currentTime] = isNaN(pbusy[currentTime]) ? 1 : pbusy[currentTime] + 1;
				flag = false;
				pbusySum++;
			}
			currentTime = 0;
		}
		else {
			flag = true;
		}
		currentTime++;

		if (length.length < server.bufferSize + 1) {
			length ~=0;
		}
		length[server.bufferSize]++;

		if (next_task-- <= 0) {
			next_task = potok.next;
			server.addTask(new Task(waits.next, time));
		}
		Task task = server.tick;
		if (task !is null) {
			sigma ~= task.sigma;
			delta ~= task.startTime - time;
		}
	}
	double prev = 0;
	double elem;

	double size = pbusy.length;
	for (int i = 0; i < size; ++i) {
		elem = isNaN(pbusy[i]) ? 0 : pbusy[i];
		prev = pbusy[i] = elem / pbusySum + prev;
	}

	size = length.length;
	prev = 0;
	for (int i = 0; i < size; ++i) {
		elem = isNaN(length[i]) ? 0 : length[i];
		prev = length[i] = elem / startTime + prev;
	}

	JSONValue result = [
		"result": "success",
	];
	result.object["length"] = convertList(length);
	result.object["pbusy"] = convertList(pbusy);
	result.object["correlation"] = JSONValue(pearson(delta, sigma));
	sw.stop;
	result.object["time"] = JSONValue(sw.peek().msecs.to!string);

	return result.toString;
}

double pearson(double[] x, double[] y) {
	// Простые суммы.
	double sumx = 0;
	double sumy = 0;

	// Суммы квадратов.
	double sum2x = 0;
	double sum2y = 0;

	// Сумма произведений.
	double production_sum = 0;

	double s = 0;
	double n = x.length;
	double a, b;
	for (int i = 0; i < n; ++i) {
		a = x[i];
		b = y[i];
		sumx += a / n;
		sumy += b / n;
		sum2x += a * a / n;
		sum2y += b * b / n;
		production_sum += a * b / n;
	}

	double num = production_sum - sumx * sumy;
	double den = sqrt(sum2x - sumx * sumx) * sqrt(sum2y - sumy * sumy);
	if (den) {
		return num / den;
	}
	if (den == 0 && num == 0) {
		return 0.91;
	}

	return 0;
}

unittest {
	auto corr = pearson([1, 2, 3], [10, 20, 29]);
	assert(corr - 0.999539 < 0.00001);

	corr = pearson([2, 3, 3], [6, 15, 29]);
	assert(corr - 0.797017 < 0.00001);
}
