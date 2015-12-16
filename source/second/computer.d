module second.computer;
import second.component;
import second.task;

class Computer {
  public uint resource;
  public uint size;

 // private SList!Task buffer;
  private Task current_task;

  this(uint resource, uint size) {
    this.resource = resource;
  }

}

