module first.server;
import first.task;
import std.container;

class Server {
  private SList!Task buffer;
  private Task task;
  public uint bufferSize = 0;

  Task tick() {
    Task result = null;
    if (this.task !is null && this.task.tick() <= 0) {
      result = this.task;
      this.task = null;
    }
    if (this.task is null) {
      if (!this.buffer.empty) {
        this.task = this.buffer.front;
        this.buffer.removeFront();
        this.bufferSize--;
      }
      else {
        // this.bufferSize = 0;
      }
    }

    return result;
  }

  void addTask(Task t) {
    if (this.task is null) {
      this.task = t;
    }
    else {
      this.buffer.insertFront(t);
      this.bufferSize++;
    }
  }

  bool isFree() {
    return this.task is null;
  }
}

unittest {
  Server s = new Server;

  Task t1 = new Task(1, 5);
  Task t2 = new Task(1, 3);
  Task t3 = new Task(2, 2);

  assert(s.isFree);

  assert(s.bufferSize == 0);
  s.addTask(t1);
  assert(s.isFree == false);
  assert(s.bufferSize == 0);
  s.addTask(t2);
  assert(s.bufferSize == 1);
  s.addTask(t3);
  assert(s.bufferSize == 2);

  assert(s.tick == t1);
  assert(s.bufferSize == 1);
  assert(s.isFree == false);

  assert(s.tick is null);
  assert(s.bufferSize == 1);

  assert(s.tick == t3);
  assert(s.bufferSize == 0);

  assert(s.isFree == false);

  assert(s.tick == t2);
  assert(s.bufferSize == 0);

  assert(s.isFree);

  assert(s.tick is null);
  assert(s.bufferSize == 0);
  assert(s.isFree);
}


