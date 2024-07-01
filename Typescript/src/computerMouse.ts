enum Status {
  off,
  ready,
  clicked,
  doubleClicked,
  pressed,
  scrolling,
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

  click(type: string) {
    let button = this.buttons.find((button) => button.type === type);
    button?.click();
  }

  doubleClick(type: string) {
    let button = this.buttons.find((button) => button.type === type);
    button?.doubleClick();
  }

  press(type: string) {
    let button = this.buttons.find((button) => button.type === type);
    button?.press();
  }

  scroll(direction: string, scrollSpeed: number, scrollTime: number) {
    this.scrollWheel.scroll(direction, scrollSpeed, scrollTime);
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
  type: string;
  state: number;

  constructor(shape: Shape, type: string, state: number) {
    this.shape = shape;
    this.type = type;
    this.state = state;
  }

  click() {
    this.state = Status.clicked;
  }

  doubleClick() {
    this.state = Status.doubleClicked;
  }

  press() {
    this.state = Status.pressed;
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
  scrollSpeed: number;
  scrollTime: number;

  constructor(shape: Shape, scrollSpeed: number) {
    this.shape = shape;
    this.direction = "";
    this.scrollSpeed = 0;
    this.scrollTime = 0;
  }

  scroll(direction: string, scrollSpeed: number, scrollTime: number) {
    this.direction = direction;
    this.scrollSpeed = scrollSpeed;
    this.scrollTime = scrollTime;
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
