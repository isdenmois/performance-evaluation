module randoms;
import std.random;
import std.math;

interface Random {

	//  Generate random number.
	double next();
}

class Exponential : Random {
	private double lambda;

	this(double lambda) {
		this.lambda = lambda;
	}

	override double next() {
		return - log(uniform01()) / this.lambda;
	}
}

class Gaussian : Random {
	private double sigma;
	private double mu;
	private double second;
	private bool isReady = false;

	this(double mu, double sigma) {
		this.mu = mu;
		this.sigma = sigma;
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

	override double next() {
		return this.generate * this.sigma + this.mu;
	}
}

class GaussianPlus : Gaussian {
	
	this(double mu, double sigma) {
		super(mu, sigma);
	}

	override public double next() {
		double result;
		do {
			result = this.next;
		} while (result <= 0);

		return result;
	}
}

class GaussianAbs : Gaussian {

	this(double mu, double sigma) {
		super(mu, sigma);
	}

	override double next() {
		return super.next.abs;
	}
}

class Rayleigh : Random {
	private double sigma;

	this(double sigma) {
		this.sigma = sigma;
	}

	override double next() {
		return this.sigma * sqrt(-2 * log(uniform01()));
	}
}

class E3 : Random {
	private double lambda;

	this(double lambda) {
		this.lambda = lambda;
	}

	override double next() {
		double u = uniform01() * uniform01() * uniform01();
		return -(1 / this.lambda) * log(u);
	}
}

class Lognormal : Gaussian {

	this(double mu, double sigma) {
		super(mu, sigma);
	}

	override double next() {
		return super.next.exp;
	}
}

