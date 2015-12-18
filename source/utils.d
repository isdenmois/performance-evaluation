module utils;
import std.json;

JSONValue convertList(double[] list) {
	JSONValue[] result = [];
	foreach (key, value; list) {
		result ~= JSONValue([
			"x": key,
			"y": value,
		]);
	}

	return JSONValue(result);
}

unittest {
	double[] list = [1, 2, 3];
	string result = convertList(list).toString;
	assert(result == "[{\"x\":0,\"y\":1},{\"x\":1,\"y\":2},{\"x\":2,\"y\":3}]");
}

