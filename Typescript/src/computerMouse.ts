enum Status {
  off = "off",
  ready = "ready",
  clicked = "clicked",
  doubleClicked = "doubleClicked",
  pressed = "pressed",
  scrolling = "scrolling",
}

class ComputerMouse {
  buttons!: Button[];
  scrollWheel!: ScrollWheel;
  shape!: Shape;
  light!: Light;
  position!: Position;
  mouseSpeed!: number;
  connectionType!: string; // wired, wireless
  status!: Status;

  move(xOffset: number, yOffset: number) {
    this.position.x = this.position.x + xOffset;
    this.position.y = this.position.y + yOffset;
  }

  click(button: Button) {
    button.click();
  }

  doubleClick(button: Button) {
    button.doubleClick();
  }

  press(button: Button) {
    button.press();
  }

  scroll(direction: string, scrollHeight: number = 10) {
    this.scrollWheel.scroll(direction, scrollHeight);
  }

  changeMouseSpeed(speed: number) {
    this.mouseSpeed = speed;
  }

  changeConnectionType(type: string) {
    this.connectionType = type;
  }

  turnOff() {
    this.status = Status.off;
  }

  turnOffLight() {
    this.light.turnOff();
  }

  turnOnLight() {
    this.light.turnOn();
  }

  changeLightColor(color: string) {
    this.light.changeColor(color);
  }

  adjustLightBrightness(brightness: number) {
    this.light.adjustBrightness(brightness);
  }
}

class Position {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

class Button {
  shape: Shape;
  type: string; // left, right, middle, side-first, side-second, side-third
  state: string;

  constructor(shape: Shape, type: string, state: string) {
    this.shape = shape;
    this.type = type;
    this.state = state;
  }

  click() {
    this.state = "clicked";
  }

  doubleClick() {
    this.state = "doubleClicked";
  }

  press() {
    this.state = "pressed";
  }
}

class Light {
  color: string;
  shape: Shape;
  brightness: number;
  status: Boolean;

  constructor(
    color: string,
    shape: Shape,
    brightness: number,
    status: Boolean
  ) {
    this.color = color;
    this.shape = shape;
    this.brightness = brightness;
    this.status = status;
  }

  turnOn() {
    this.status = true;
  }

  turnOff() {
    this.status = false;
  }

  changeColor(color: string) {
    this.color = color;
  }

  adjustBrightness(brightness: number) {
    this.brightness = brightness;
  }
}

class ScrollWheel {
  shape: Shape;
  direction: string;
  scrollHeight: number;

  constructor(shape: Shape, scrollHeight: number) {
    this.shape = shape;
    this.direction = "";
    this.scrollHeight = scrollHeight;
  }

  scroll(direction: string, scrollHeight: number) {
    this.direction = direction;
    this.scrollHeight = scrollHeight;
  }

  press() {
    console.log("Scroll wheel pressed");
  }
}

class Shape {
  length: number;
  width: number;
  height: number;
  color: string;

  constructor(length: number, width: number, height: number, color: string) {
    this.length = length;
    this.width = width;
    this.height = height;
    this.color = color;
  }
}

export { ComputerMouse, Position, Button, Light, ScrollWheel, Shape };
