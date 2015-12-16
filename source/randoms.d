module randoms;
import std.random;
import std.math;

class Exponential {
	private double lambda;

	this(double lambda) {
		this.lambda = lambda;
	}

	double next() {
		return - log(uniform01()) / this.lambda;
	}
}

class Gaussian {
	private double sigma;
	private double mu;
	private double second;
	private bool isReady = false;

	this(double sigma, double mu) {
		this.sigma = sigma;
		this.mu = mu;
	}

	protected double generate() {
		if (isReady) {
			isReady = false;
			return second;
		}

		double x, y, w;
		do {
			x = uniform(-1.0, 1.0);
			y = uniform(-1.0, 1.0);
			w = (x * x) + (y * y);
		} while ((w >= 1.0) || (w == 0.0));

		w = sqrt((-2.0 * log(w)) / w);

		second = y * w;
		isReady = true;

		return x * w;
	}

	public double next() {
		return this.generate * this.sigma + this.mu;
	}
}

class GaussianPlus : Gaussian {
	
	this(double sigma, double mu) {
		super(sigma, mu);
	}

	override public double next() {
		double result;
		do {
			result = this.generate;
		} while (result <= 0);

		return result * this.sigma + this.mu;
	}
}

