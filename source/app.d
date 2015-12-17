module main;
import vibe.web.rest;
import vibe.d;
import first.first;
import second.second;
import std.json;


// Defines a RESTful API.
interface PVIface {
	@method(HTTPMethod.GET)
	string computeFirst(uint time, double lambda, double mu, double sigma);

	@method(HTTPMethod.GET)
	string computeSecond(uint k, double task_lambda, double TR1_sigma, double TR1_mu, double TR2, double TR3, double TR4_sigma, double TR4_mu, double TR5_sigma, double TR5_mu);
}

class PV : PVIface {
	@method(HTTPMethod.GET)
	string computeFirst(uint time, double lambda, double mu, double sigma) {
		return first_process(time, lambda, mu, sigma);
	}

	@method(HTTPMethod.GET)
	string computeSecond(uint k, double task_lambda, double TR1_sigma, double TR1_mu, double TR2, double TR3, double TR4_sigma, double TR4_mu, double TR5_sigma, double TR5_mu) {
		return second_process(k, task_lambda, TR1_sigma, TR1_mu, TR2, TR3, TR4_sigma, TR4_mu, TR5_sigma, TR5_mu);
	}
}

void index(HTTPServerRequest req, HTTPServerResponse res) {
	string[][] nav = [["Задача 1", "/first"], ["Задача 2", "/second"]];
	string title = "Методы оценки вычислений";
	res.render!("index.dt", title, nav);
}

void first_route(HTTPServerRequest req, HTTPServerResponse res) {
	string[][] nav = [["Задача 1", "/first"], ["Задача 2", "/second"]];
	string title = "Задача 1. Простой сервер.";
	res.render!("first.dt", title, nav);
}

void second_route(HTTPServerRequest req, HTTPServerResponse res) {
	string[][] nav = [["Задача 1", "/first"], ["Задача 2", "/second"]];
	string title = "Задача 2. Модульная компьютерная система.";
	res.render!("second.dt", title, nav);
}

shared static this()
{
	import vibe.core.log : logInfo;
	import vibe.inet.url : URL;
	import vibe.http.router : URLRouter;
	import vibe.http.server : HTTPServerSettings, listenHTTP, staticTemplate;

	// REST settings for js.
	auto restsettings = new RestInterfaceSettings;
	restsettings.baseURL = URL("http://127.0.0.1:8080/");

	auto router = new URLRouter;
	router
		.get("/performance_evaluation.js", serveRestJSClient!PVIface(restsettings))
		.get("/", &index)
		.get("/first", &first_route)
		.get("/second", &second_route)
		// Serve static files.
		.get("*", serveStaticFiles("./node_modules"))
		.get("*", serveStaticFiles("./public"));

	// Finally register the REST class.
	router.registerRestInterface(new PV);

	auto settings = new HTTPServerSettings;
	settings.port = 8080;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8080/ in your browser.");
}

void main() {
	// returns false if a help screen has been requested and displayed (--help)
	if (!finalizeCommandLineOptions())
		return;
	lowerPrivileges();
	runEventLoop();
}
