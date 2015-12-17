module second.component;

class Component {
  public uint type;
  private double sigma;

  this(uint type, double sigma) {
    this.type = type;
    this.sigma = sigma;
  }

  public double tick() {
    return --this.sigma;
  }
}
