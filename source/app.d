module main;
import vibe.web.rest;
import vibe.d;
import first.first;


// Defines a simple RESTful API
interface PV {
	@method(HTTPMethod.GET)
	string computeFirst(uint time, double lambda, double sigma, double mu);
}

// Local implementation that will be provided by the server
class Test : PV {
	import std.stdio;
	float computeSum(float a, float b) { return a + b; }
	void postToConsole(string text) { writeln(text); }
	string computeFirst(uint time, double lambda, double sigma, double mu) {
		return first_process(time, lambda, sigma, mu);
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

void bower(scope HTTPServerRequest req, scope HTTPServerResponse res, ref string rr) {
	import std.stdio;
	writeln(rr);
}

shared static this()
{
	import vibe.core.log : logInfo;
	import vibe.inet.url : URL;
	import vibe.http.router : URLRouter;
	import vibe.http.server : HTTPServerSettings, listenHTTP, staticTemplate;

	// Set up the proper base URL, so that the JavaScript client
	// will find our REST service
	auto restsettings = new RestInterfaceSettings;
	restsettings.baseURL = URL("http://127.0.0.1:8080/");

	auto router = new URLRouter;
	// Serve the generated JavaScript client at /performance_evaluation.js
	router.get("/performance_evaluation.js", serveRestJSClient!PV(restsettings));
	// Serve an example page at /
	// The page will use the test.js script to issue calls to the
	// REST service.
	router.get("/", &index);
	router.get("/first", &first_route);

	// Serve static files.
	router.get("*", serveStaticFiles("./node_modules"));
	router.get("*", serveStaticFiles("./public"));

	// Finally register the REST interface defined above
	router.registerRestInterface(new Test, restsettings);

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
