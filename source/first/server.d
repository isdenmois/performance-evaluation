module first.server;
import first.task;
import std.container;

class Server {
  private SList!Task buffer;
  private Task task;
  public bool isFree = true;
  public uint bufferSize = 0;

  Task tick() {
    Task result = null;
    if (this.task is null) {
      if (!this.buffer.empty) {
        this.task = this.buffer.front;
        this.buffer.removeFront();
        this.isFree = false;
        this.bufferSize--;
      }
      else {
        this.isFree = true;
      }
    }
    if (this.task !is null && this.task.tick() <= 0) {
      result = this.task;
      this.task = null;
    }

    return result;
  }

  void addTask(Task t) {
    this.buffer.insertFront(t);
    this.bufferSize++;
  }
}
