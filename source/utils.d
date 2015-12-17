module utils;
import std.json;

JSONValue convertList(double[] list) {
	JSONValue[] result;
	foreach (key, value; list) {
		result ~= JSONValue([
			"x": key,
			"y": value,
		]);
	}

	return JSONValue(result);
}
